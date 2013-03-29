//
//  ViewController.m
//  CameraTest
//
//  Created by Camillus Gerard Cai on 12/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//


#import <AVFoundation/AVFoundation.h>
#import "ViewController.h"

@interface ViewController ()
@property (strong) TimedChunkingVideoRecorder *_capture;
@property (strong) NSString *_defaultDocumentDirectory;

- (void) enableAllButtons;
- (void) disableButtonsForManualChunking;
- (void) disableButtonsForTimedChunking;

@end

@implementation ViewController
// Storyboard elements.
@synthesize previewView;
@synthesize startRecordingButton;
@synthesize stopRecordingButton;
@synthesize chunkRecordingButton;

// Programmatic elements.
@synthesize _capture;
@synthesize _defaultDocumentDirectory;

- (void) viewDidLoad {
    [super viewDidLoad];
    _defaultDocumentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    _capture = [[TimedChunkingVideoRecorder alloc] initWithPreset:AVCaptureSessionPresetMedium];
    _capture.delegate = self;
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
    [_capture startTimedRecordingToDirectory:_defaultDocumentDirectory chunkInterval:10.];
    [self disableButtonsForTimedChunking];
}

- (void) chunkingVideoRecorder:(ChunkingVideoRecorder *)recorder didChunk:(NSURL *)chunk index:(NSUInteger)index {
    NSLog(@"new chunk=%@ index=%d", chunk, index);
}

- (void) chunkingVideoRecorder:(ChunkingVideoRecorder *)recorder didStopRecordingWithChunk:(NSURL *)chunk index:(NSUInteger)index {
    NSLog(@"recoding stopped. last chunk=%@ index=%d", chunk, index);
}

- (void) chunkingVideoRecorderDidStartRecording:(ChunkingVideoRecorder *)recorder {
    NSLog(@"recording started!");
}

- (void) enableAllButtons {
    startRecordingButton.enabled = YES;
    stopRecordingButton.enabled = NO;
    chunkRecordingButton.enabled = NO;
}

- (void) disableButtonsForManualChunking {
    startRecordingButton.enabled = NO;
    stopRecordingButton.enabled = YES;
    chunkRecordingButton.enabled = YES;
}

- (void) disableButtonsForTimedChunking {
    startRecordingButton.enabled = NO;
    stopRecordingButton.enabled = YES;
    chunkRecordingButton.enabled = NO;
}

@end
