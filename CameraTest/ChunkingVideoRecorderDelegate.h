//
//  ChunkingVideoRecorderDelegate.h
//  CameraTest
//
//  Created by Camillus Gerard Cai on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChunkingVideoRecorder.h"

@class ChunkingVideoRecorder;

@protocol ChunkingVideoRecorderDelegate <NSObject>
- (void) chunkingVideoRecorderDidStartRecording:(ChunkingVideoRecorder *)recorder;
- (void) chunkingVideoRecorder:(ChunkingVideoRecorder *)recorder didStopRecordingWithChunk:(NSURL *)chunk index:(NSUInteger)index;
- (void) chunkingVideoRecorder:(ChunkingVideoRecorder *)recorder didChunk:(NSURL *)chunk index:(NSUInteger)index;

@end
