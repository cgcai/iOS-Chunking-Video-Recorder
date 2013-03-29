//
//  ChunkingVideoRecorder.h
//  CameraTest
//
//  Created by Camillus Gerard Cai on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "ChunkingVideoRecorderDelegate.h"

@interface ChunkingVideoRecorder : NSObject <AVCaptureFileOutputRecordingDelegate>
@property (weak) id<ChunkingVideoRecorderDelegate> delegate;
@property (atomic, readonly) BOOL isPreviewing;
@property (atomic, readonly) BOOL isRecording;
@property (strong) AVCaptureVideoPreviewLayer *previewLayer;

- (id) initWithPreset:(NSString *)preset;
- (AVCaptureVideoPreviewLayer *) startPreview;
- (void) stopPreview;
- (void) startRecordingToDirectory:(NSString *)directory;
- (void) stopRecording;
- (void) chunk;

@end
