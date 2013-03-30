//
//  HLSEventProducer.h
//  CameraTest
//
//  Created by Camillus Gerard Cai on 30/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "HLSEventProducerDelegate.h"
#import "HLSEventPlaylistHelper.h"
#import "TimedChunkingVideoRecorder.h"
#import "ChunkingVideoRecorderDelegate.h"

@interface HLSEventProducer : NSObject <ChunkingVideoRecorderDelegate>
@property (weak) id<HLSEventProducerDelegate> delegate;
@property (atomic, readonly) BOOL isPreviewing;
@property (atomic, readonly) BOOL isRecording;
@property (readonly, strong) AVCaptureVideoPreviewLayer *previewLayer;

- (id) initWithDelegate:(id<HLSEventProducerDelegate>)del playlistDirectory:(NSString *)dir chunkDuration:(CGFloat)interval videoPreset:(NSString *)preset;
- (NSInteger) startNewRecording;
- (void) endRecording;

@end
