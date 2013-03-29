//
//  ChunkedVideoCapture.m
//  Channely
//
//  Created by Camillus Gerard Cai on 14/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChunkedVideoCapture.h"

@interface ChunkedVideoCapture ()
// External.
@property (atomic, readwrite) BOOL isPreviewing;
@property (atomic, readwrite) BOOL isRecording;
@property (strong, readwrite) AVCaptureVideoPreviewLayer *previewLayer;

// Internal.
@property (strong) NSString *_preset;
@property (strong) AVCaptureSession *_session;
@property (strong) AVCaptureMovieFileOutput *movieFileOutput;
@property (atomic) NSUInteger _chunkId;
@property (strong) NSString *_documentDirectory;
@property (atomic) BOOL _shouldChunk;
@property (atomic) BOOL _isTimedRecording;
@property (strong) NSTimer *_chunkTimer;
@property (strong) NSString *_directory;

@end

@interface ChunkedVideoCapture (DefaultDevices)
- (AVCaptureDevice *) getCameraInput;
- (AVCaptureDeviceInput *) getMicInput;

@end

@interface ChunkedVideoCapture (Chunking)
- (void) startRecording;
- (NSURL *) getOutputFileURL;
- (void) captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections;
- (void) captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error;
- (void) timerTick:(NSTimer *)sender;
- (void) clearDocumentsDirectory;

@end

@implementation ChunkedVideoCapture
@synthesize _preset;
@synthesize isPreviewing;
@synthesize previewLayer;
@synthesize _session;
@synthesize isRecording;
@synthesize movieFileOutput;
@synthesize _chunkId;
@synthesize _documentDirectory;
@synthesize _shouldChunk;
@synthesize _isTimedRecording;
@synthesize _chunkTimer;
@synthesize delegate;

- (id) initWithPreset:(NSString *)sessionPreset {
    if (self = [super init]) {
        _preset = sessionPreset;
        _documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
    return self;
}

- (void) startSession {
    _session = [[AVCaptureSession alloc] init];
    
    [_session beginConfiguration];
    _session.sessionPreset = _preset;
    [_session addInput:(AVCaptureInput *)[self getCameraInput]];    // Attach video stream.
    [_session addInput:(AVCaptureInput *)[self getMicInput]];       // Attach audio stream.
    [_session commitConfiguration];
    
    [_session startRunning];
    
    previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    isPreviewing = YES;
}

- (void) stopSession {
    if (isRecording) {
        [self stopRecording];
    }
    
    [_session stopRunning];
    isPreviewing = NO;
}

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

- (void) startRecordingWithChunkTimer:(NSUInteger)seconds {
    _chunkId = 0;
    [self clearDocumentsDirectory];
    
    [self startRecording];
    isRecording = YES;
    
    _isTimedRecording = YES;
    _chunkTimer = [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    
    if (delegate) {
        [delegate videoCapture:self didStartRecordingToDirectory:_documentDirectory];
    }
}

- (void) timerTick:(NSTimer *)sender {
    [self chunkNow];
}

- (void) startRecordingWithManualChunking {
    _chunkId = 0;
    [self clearDocumentsDirectory];

    [self startRecording];
    isRecording = YES;
    
    if (delegate) {
        [delegate videoCapture:self didStartRecordingToDirectory:_documentDirectory];
    }
}

- (void) startRecording {
    movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    
    [_session addOutput:movieFileOutput];
    [movieFileOutput startRecordingToOutputFileURL:[self getOutputFileURL] recordingDelegate:self];
}

- (NSURL *) getOutputFileURL {
    NSString *outputFile = [NSString stringWithFormat:@"%@/chunk%d.mp4", _documentDirectory, _chunkId++];
    return [NSURL fileURLWithPath:outputFile];
}

- (void) captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections {
    // Debug:
    NSLog(@"started writing to file: %@", fileURL);
}

- (void) captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {   
    // Log errors.
    if (error) {
        NSLog(@"%@", error);
    }
    
    if (_shouldChunk) {
        // Restart recording if the previous file output was stopped due to a chunk request.
        
        [movieFileOutput startRecordingToOutputFileURL:[self getOutputFileURL] recordingDelegate:self];
        if (delegate) {
            [delegate videoCapture:self didChunkVideoInDirectory:_documentDirectory];
        }
    } else {
        // Otherwise terminate permanently.
        
        [_session removeOutput:captureOutput];
        movieFileOutput = nil;
        
        if (delegate) {
            [delegate videoCapture:self didStopRecordingToDirectory:_documentDirectory];
        }
    }
}

// Removes all files from app's documents directory.
// Ref: http://stackoverflow.com/questions/4793278/deleting-all-the-files-in-the-iphone-sandbox-documents-folder
- (void) clearDocumentsDirectory {
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSError *error = nil;
    
    NSArray *files = [fileManager contentsOfDirectoryAtPath:_documentDirectory error:&error];
    if (error) {
        NSLog(@"Could not get list of files in document directory.");
        return;
    }
    
    for (NSString *path in files) {
        NSString *fullPath = [_documentDirectory stringByAppendingPathComponent:path];
        
        BOOL removed = [fileManager removeItemAtPath:fullPath error:&error];
        if (!removed) {
            NSLog(@"Could not remove file: %@", fullPath);
        }
    }
}

- (void) stopRecording {
    if (_isTimedRecording) {
        [_chunkTimer invalidate];
    }
    
    _shouldChunk = NO;
    [movieFileOutput stopRecording];
    isRecording = NO;
}

- (void) chunkNow {
    _shouldChunk = YES;
    [movieFileOutput stopRecording];
}

@end
