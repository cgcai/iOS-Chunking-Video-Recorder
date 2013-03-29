//
//  ChunkingVideoRecorder.m
//  CameraTest
//
//  Created by Camillus Gerard Cai on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChunkingVideoRecorder.h"

@interface ChunkingVideoRecorder ()
// Redefinitions.
@property (atomic, readwrite) BOOL isPreviewing;
@property (atomic, readwrite) BOOL isRecording;

// Internal.
@property (strong) AVCaptureSession *_session;
@property (strong) NSString *_preset;
@property (atomic) NSUInteger _chunkIndex;
@property (strong) AVCaptureMovieFileOutput *_movieFileOutput;
@property (atomic) BOOL _videoRecordingPermanentStop;
@property (atomic) BOOL _videoRecordingChunkStop;
@property (strong) NSString *_recordingDirectory;

- (AVCaptureDevice *) getCameraInput;
- (AVCaptureDeviceInput *) getMicInput;
- (void) clearDirectory:(NSString *)directory;
- (NSURL *) newChunkUrlInDirectory:(NSString *)directory;
- (void) resetChunkId;
- (NSUInteger) getAndIncrementChunkId;
- (NSUInteger) peekChunkId;

@end

@implementation ChunkingVideoRecorder
// External.
@synthesize delegate;
@synthesize isPreviewing;
@synthesize isRecording;
@synthesize previewLayer;

// Internal.
@synthesize _session;
@synthesize _preset;
@synthesize _chunkIndex;
@synthesize _movieFileOutput;
@synthesize _videoRecordingPermanentStop;
@synthesize _videoRecordingChunkStop;
@synthesize _recordingDirectory;

#pragma mark Constructors
- (id) initWithPreset:(NSString *)preset {
    if (self = [super init]) {
        _preset = preset;
        
        isPreviewing = NO;
        isRecording = NO;
        
        [self resetChunkId];
    }
    return self;
}

#pragma mark Preview
- (AVCaptureVideoPreviewLayer *) startPreview {
    _session = [[AVCaptureSession alloc] init];
    
    [_session beginConfiguration];
    _session.sessionPreset = _preset;
    [_session addInput:(AVCaptureInput *)[self getCameraInput]];    // Attach video stream.
    [_session addInput:(AVCaptureInput *)[self getMicInput]];       // Attach audio stream.
    [_session commitConfiguration];
    
    [_session startRunning];
    
    previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    isPreviewing = YES;
    
    return previewLayer;
}

- (void) stopPreview {
    if (isRecording) {
        [self stopRecording];
    }
    
    [_session stopRunning];
    isPreviewing = NO;
}

#pragma mark Recording
- (void) startRecordingToDirectory:(NSString *)directory {
    _recordingDirectory = directory;
    
    [self resetChunkId];
    [self clearDirectory:_recordingDirectory];
    
    NSURL *initialChunk = [self newChunkUrlInDirectory:_recordingDirectory];
    _movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    [_session addOutput:_movieFileOutput];
    [_movieFileOutput startRecordingToOutputFileURL: initialChunk recordingDelegate:self];
    
    isRecording = YES;
    if (delegate) {
        [delegate chunkingVideoRecorderDidStartRecording:self];
    }    
}

- (void) stopRecording {
    _videoRecordingPermanentStop = YES;
    _videoRecordingChunkStop = NO;
    
    [_movieFileOutput stopRecording];
    isRecording = NO;
}

- (void) chunk {
    _videoRecordingPermanentStop = NO;
    _videoRecordingChunkStop = YES;
    
    [_movieFileOutput stopRecording];
}

#pragma mark AVCaptureFileOutputRecordingDelegate Methods
- (void) captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections {
    // Not used.
}

- (void) captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    if (error) {
        NSLog(@"%@", error);
        return;
    }
    
    if (_videoRecordingChunkStop) {
        if (delegate) {
            [delegate chunkingVideoRecorder:self didChunk:outputFileURL index:[self peekChunkId]];
        }
        
        // Restart recording if the previous file output was stopped due to a chunk request.
        NSURL *nextChunk = [self newChunkUrlInDirectory:_recordingDirectory];
        [_movieFileOutput startRecordingToOutputFileURL:nextChunk recordingDelegate:self];
        
    } else if (_videoRecordingPermanentStop) {
        // Otherwise terminate permanently.
        [_session removeOutput:_movieFileOutput];
        _movieFileOutput = nil;
        if (delegate) {
            [delegate chunkingVideoRecorder:self didStopRecordingWithChunk:outputFileURL index:[self peekChunkId]];
        }
    }
}

#pragma mark Convenience Methods
- (AVCaptureDeviceInput *) getCameraInput {
    AVCaptureDevice *defCamera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error = nil;
    AVCaptureDeviceInput *cameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:defCamera error:&error];
    if (error) {
        NSLog(@"Could not get camera.");
    }
    return cameraInput;
}

- (AVCaptureDeviceInput *) getMicInput {
    AVCaptureDevice *defMic = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    
    NSError *error = nil;
    AVCaptureDeviceInput *micInput = [[AVCaptureDeviceInput alloc] initWithDevice:defMic error:&error];
    if (error) {
        NSLog(@"Could not get microphone.");
    }
    return micInput;
}

// Removes all files from app's documents directory.
// Ref: http://stackoverflow.com/questions/4793278/deleting-all-the-files-in-the-iphone-sandbox-documents-folder
- (void) clearDirectory:(NSString *)directory {
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSError *error = nil;
    
    NSArray *files = [fileManager contentsOfDirectoryAtPath:directory error:&error];
    if (error) {
        NSLog(@"Could not get list of files in document directory.");
        return;
    }
    
    for (NSString *path in files) {
        NSString *fullPath = [directory stringByAppendingPathComponent:path];
        
        BOOL removed = [fileManager removeItemAtPath:fullPath error:&error];
        if (!removed) {
            NSLog(@"Could not remove file: %@", fullPath);
        }
    }
}

- (void) resetChunkId {
    _chunkIndex = 0;
}

- (NSUInteger) getAndIncrementChunkId {
    return (_chunkIndex++);
}

- (NSURL *) newChunkUrlInDirectory:(NSString *)directory {
    NSString *outputFile = [NSString stringWithFormat:@"%@/chunk%d.mp4", directory, [self getAndIncrementChunkId]];
    return [NSURL fileURLWithPath:outputFile];
}

- (NSUInteger) peekChunkId {
    return _chunkIndex;
}

@end
