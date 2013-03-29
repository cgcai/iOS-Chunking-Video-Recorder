//
//  ChunkedVideoCapture.h
//  Channely
//
//  Created by Camillus Gerard Cai on 14/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "VideoCaptureDelegate.h"
#import "VideoCapture.h"

@interface ChunkedVideoCapture : NSObject <VideoCapture, AVCaptureFileOutputRecordingDelegate>
@property (atomic, readonly) BOOL isPreviewing;
@property (atomic, readonly) BOOL isRecording;
@property (atomic) id<VideoCaptureDelegate> delegate;
@property (strong, readonly) AVCaptureVideoPreviewLayer *previewLayer;

- (id) initWithPreset:(NSString *)sessionPreset;
- (void) startSession;
- (void) stopSession;
- (void) startRecordingWithChunkTimer:(NSUInteger)seconds;
- (void) startRecordingWithManualChunking;
- (void) stopRecording;
- (void) chunkNow;

@end
