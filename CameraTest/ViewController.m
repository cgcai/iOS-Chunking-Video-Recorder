//
//  ViewController.m
//  CameraTest
//
//  Created by Camillus Gerard Cai on 12/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//


#import "ViewController.h"

@interface ViewController ()
@property (strong) HLSEventProducer *_producer;
@property (strong) NSString *_defaultDocumentDirectory;

- (void) enableAllButtons;
- (void) disableButtonsForTimedChunking;

@end

@implementation ViewController
// Storyboard elements.
@synthesize previewView;
@synthesize startTimedRecordingButton;
@synthesize stopRecordingButton;

// Programmatic elements.
@synthesize _producer;
@synthesize _defaultDocumentDirectory;

- (void) viewDidLoad {
    [super viewDidLoad];
    _defaultDocumentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    _producer = [[HLSEventProducer alloc] initWithDelegate:self playlistDirectory:_defaultDocumentDirectory chunkDuration:4. videoPreset:AVCaptureSessionPresetMedium];
}

- (void) viewDidLayoutSubviews {
    [self enableAllButtons];
    
    _producer.previewLayer.frame = previewView.frame;
    _producer.previewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [previewView.layer addSublayer:_producer.previewLayer];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (IBAction) stopRecordingHandler:(id)sender {
    [_producer endRecording];
    [self enableAllButtons];
}

- (IBAction)startTimedRecordingHandler:(id)sender {
    [_producer startNewRecording];
    [self disableButtonsForTimedChunking];
}

- (void) enableAllButtons {
    startTimedRecordingButton.enabled = YES;
    stopRecordingButton.enabled = NO;
}

- (void) disableButtonsForTimedChunking {
    startTimedRecordingButton.enabled = NO;
    stopRecordingButton.enabled = YES;
}

- (NSInteger) newRecordingId {
    return 1;
}

@end
