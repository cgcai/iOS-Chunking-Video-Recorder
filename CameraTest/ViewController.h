//
//  ViewController.h
//  CameraTest
//
//  Created by Camillus Gerard Cai on 12/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChunkingVideoRecorder.h"

@interface ViewController : UIViewController <ChunkingVideoRecorderDelegate>
@property (strong, nonatomic) IBOutlet UIView *previewView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *startRecordingButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *stopRecordingButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *chunkRecordingButton;

- (IBAction)startRecordingHandler:(id)sender;
- (IBAction)stopRecordingHandler:(id)sender;
- (IBAction)chunkRecordingHandler:(id)sender;

@end
