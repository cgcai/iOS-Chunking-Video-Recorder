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
- (void) recorderDidStartRecording:(ChunkingVideoRecorder *)recorder;
- (void) recorder:(ChunkingVideoRecorder *)recorder didStopRecordingWithChunk:(NSURL *)chunk index:(NSUInteger)index duration:(NSTimeInterval)duration;
- (void) recorder:(ChunkingVideoRecorder *)recorder didChunk:(NSURL *)chunk index:(NSUInteger)index duration:(NSTimeInterval)duration;

@end
