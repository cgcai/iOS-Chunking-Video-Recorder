//
//  ViewController.m
//  CameraTest
//
//  Created by Camillus Gerard Cai on 12/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//


#import "ViewController.h"

@interface ViewController ()
@property (strong) TimedChunkingVideoRecorder *_capture;
@property (strong) HLSEventPlaylistHelper *_playlistHelper;
@property (strong) NSString *_defaultDocumentDirectory;

- (void) enableAllButtons;
- (void) disableButtonsForManualChunking;
- (void) disableButtonsForTimedChunking;

@end

@implementation ViewController
// Storyboard elements.
@synthesize previewView;
@synthesize startRecordingButton;
@synthesize startTimedRecordingButton;
@synthesize stopRecordingButton;
@synthesize chunkRecordingButton;

// Programmatic elements.
@synthesize _capture;
@synthesize _defaultDocumentDirectory;
@synthesize _playlistHelper;

- (void) viewDidLoad {
    [super viewDidLoad];
    _defaultDocumentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    _capture = [[TimedChunkingVideoRecorder alloc] initWithPreset:AVCaptureSessionPresetMedium];
    _capture.delegate = self;
    
    NSString *playlistPath = [_defaultDocumentDirectory stringByAppendingPathComponent:@"playlist.m3u8"];
    NSURL *playlistURL = [[NSURL alloc] initFileURLWithPath:playlistPath];
    _playlistHelper = [[HLSEventPlaylistHelper alloc] initWithFileURL:playlistURL];
}

- (void) viewDidLayoutSubviews {
    [_capture startPreview];
    _capture.previewLayer.frame = previewView.frame;
    _capture.previewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [previewView.layer addSublayer:_capture.previewLayer];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (IBAction) startRecordingHandler:(id)sender {
    [_capture startRecordingToDirectory:_defaultDocumentDirectory];
    [self disableButtonsForManualChunking];
}

- (IBAction) stopRecordingHandler:(id)sender {
    [_capture stopRecording];
    [self enableAllButtons];
}

- (IBAction) chunkRecordingHandler:(id)sender {
    [_capture chunk];
}

- (IBAction)startTimedRecordingHandler:(id)sender {
    [_capture startTimedRecordingToDirectory:_defaultDocumentDirectory chunkInterval:10];
    [self disableButtonsForTimedChunking];
}

- (void) recorder:(ChunkingVideoRecorder *)recorder didChunk:(NSURL *)chunk index:(NSUInteger)index duration:(NSTimeInterval)duration{
    NSLog(@"new chunk=%@ index=%d duration=%lf", chunk, index, duration);
    
    [_playlistHelper appendItem:[chunk relativePath] withDuration:10];
}

- (void) recorder:(ChunkingVideoRecorder *)recorder didStopRecordingWithChunk:(NSURL *)chunk index:(NSUInteger)index duration:(NSTimeInterval)duration{
    NSLog(@"recoding stopped. last chunk=%@ index=%d duration=%lf", chunk, index, duration);
    
    [_playlistHelper appendItem:[chunk relativePath] withDuration:10];
    [_playlistHelper endPlaylist];
}

- (void) recorderDidStartRecording:(ChunkingVideoRecorder *)recorder {
    NSLog(@"recording started!");
    
    [_playlistHelper beginPlaylistWithTargetInterval:12];
}

- (void) enableAllButtons {
    startRecordingButton.enabled = YES;
    startTimedRecordingButton.enabled = YES;
    stopRecordingButton.enabled = NO;
    chunkRecordingButton.enabled = NO;
}

- (void) disableButtonsForManualChunking {
    startRecordingButton.enabled = NO;
    startTimedRecordingButton.enabled = NO;
    stopRecordingButton.enabled = YES;
    chunkRecordingButton.enabled = YES;
}

- (void) disableButtonsForTimedChunking {
    startRecordingButton.enabled = NO;
    startTimedRecordingButton.enabled = NO;
    stopRecordingButton.enabled = YES;
    chunkRecordingButton.enabled = NO;
}

@end
