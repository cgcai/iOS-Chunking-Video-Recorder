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
@property (strong) ChunkedVideoCapture *capture;

@end

@implementation ViewController
// Storyboard elements.
@synthesize previewView;
@synthesize startRecordingButton;
@synthesize stopRecordingButton;
@synthesize chunkRecordingButton;
@synthesize startChunkedRecordingButton;

// Programmatic elements.
@synthesize capture;

- (void) viewDidLoad {
    [super viewDidLoad];
    capture = [[ChunkedVideoCapture alloc] initWithPreset:AVCaptureSessionPresetMedium];
    capture.delegate = self;
}

- (void) viewDidLayoutSubviews {
    [capture startSession];
    
    capture.previewLayer.frame = previewView.frame;
    capture.previewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [previewView.layer addSublayer:capture.previewLayer];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) startRecordingHandler:(id)sender {
    [capture startRecordingWithManualChunking];
    
    startRecordingButton.enabled = NO;
    startChunkedRecordingButton.enabled = NO;
    stopRecordingButton.enabled = YES;
    chunkRecordingButton.enabled = YES;
}

- (IBAction) stopRecordingHandler:(id)sender {
    [capture stopRecording];
    
    startRecordingButton.enabled = YES;
    startChunkedRecordingButton.enabled = YES;
    stopRecordingButton.enabled = NO;
    chunkRecordingButton.enabled = NO;
}

- (IBAction) chunkRecordingHandler:(id)sender {
    [capture chunkNow];
}

- (IBAction)startChunkedRecordingHandler:(id)sender {
    [capture startRecordingWithChunkTimer:10];
    
    startRecordingButton.enabled = NO;
    startChunkedRecordingButton.enabled = NO;
    stopRecordingButton.enabled = YES;
    chunkRecordingButton.enabled = NO;
}

- (void) videoCapture:(ChunkedVideoCapture *)sender didChunkVideoInDirectory:(NSString *)path {
    NSLog(@"new chunk!");
}

- (void) videoCapture:(ChunkedVideoCapture *)sender didStartRecordingToDirectory:(NSString *)path {
    NSLog(@"recording started!");
}

- (void) videoCapture:(ChunkedVideoCapture *)sender didStopRecordingToDirectory:(NSString *)path {
    NSLog(@"recoding stopped.");
}

@end
