//
//  ViewController.h
//  CameraTest
//
//  Created by Camillus Gerard Cai on 12/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "HLSEventProducer.h"
#import "HLSEventProducerDelegate.h"

@interface ViewController : UIViewController <HLSEventProducerDelegate>
@property (strong, nonatomic) IBOutlet UIView *previewView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *stopRecordingButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *startTimedRecordingButton;

- (IBAction)stopRecordingHandler:(id)sender;
- (IBAction)startTimedRecordingHandler:(id)sender;

@end
