//
//  ViewController.h
//  CameraTest
//
//  Created by Camillus Gerard Cai on 12/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "TimedChunkingVideoRecorder.h"
#import "HLSEventPlaylistHelper.h"

@interface ViewController : UIViewController <ChunkingVideoRecorderDelegate>
@property (strong, nonatomic) IBOutlet UIView *previewView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *startRecordingButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *stopRecordingButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *chunkRecordingButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *startTimedRecordingButton;

- (IBAction)startRecordingHandler:(id)sender;
- (IBAction)stopRecordingHandler:(id)sender;
- (IBAction)chunkRecordingHandler:(id)sender;
- (IBAction)startTimedRecordingHandler:(id)sender;

@end
