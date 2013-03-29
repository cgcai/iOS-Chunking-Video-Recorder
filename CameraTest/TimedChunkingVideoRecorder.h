//
//  TimedChunkingVideoRecorder.h
//  CameraTest
//
//  Created by Camillus Gerard Cai on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ChunkingVideoRecorder.h"

@interface TimedChunkingVideoRecorder : ChunkingVideoRecorder
@property (atomic, readonly) NSUInteger interval;

- (id) initWithPreset:(NSString *)preset;
- (void) startTimedRecordingToDirectory:(NSString *)directory chunkInterval:(NSUInteger)period;
- (void) stopRecording;

@end
