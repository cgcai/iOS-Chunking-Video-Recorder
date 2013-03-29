//
//  VideoCapture.h
//  Channely
//
//  Created by Camillus Gerard Cai on 14/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol VideoCapture <NSObject>
- (AVCaptureVideoPreviewLayer *) previewLayer;
- (BOOL) isPreviewing;
- (BOOL) isRecording;
- (void) startSession;
- (void) stopSession;
- (void) startRecordingWithChunkTimer:(NSUInteger) seconds;
- (void) startRecordingWithManualChunking;
- (void) stopRecording;
- (void) chunkNow;

@end
