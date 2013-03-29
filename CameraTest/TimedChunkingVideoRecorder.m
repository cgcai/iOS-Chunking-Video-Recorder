//
//  TimedChunkingVideoRecorder.m
//  CameraTest
//
//  Created by Camillus Gerard Cai on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "TimedChunkingVideoRecorder.h"

@interface TimedChunkingVideoRecorder ()
// Redefinitions.
@property (atomic, readwrite) NSUInteger interval;

// Internal.
@property (strong) NSTimer *_chunkTimer;

- (void) timerDidFire:(NSTimer *)timer;

@end

@implementation TimedChunkingVideoRecorder
// External.
@synthesize interval;

// Internal.
@synthesize _chunkTimer;

#pragma mark Overriden Constructor
- (id) initWithPreset:(NSString *)preset {
    if (self = [super initWithPreset:preset]) {
        interval = 0.;
        
        _chunkTimer = nil;
    }
    return self;
}

#pragma mark Timed Chunking
- (void) startTimedRecordingToDirectory:(NSString *)directory chunkInterval:(NSUInteger)period {
    interval = period;
    [self startRecordingToDirectory:directory];
    if (interval != 0.) {
        NSDate *firstChunk = [[NSDate date] dateByAddingTimeInterval:interval];
        _chunkTimer = [[NSTimer alloc] initWithFireDate:firstChunk interval:interval target:self selector:@selector(timerDidFire:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_chunkTimer forMode:NSDefaultRunLoopMode];
    }
}

- (void) timerDidFire:(NSTimer *)timer {
    if (self.isRecording) {
        [self chunk];
    }
}

- (void) stopRecording {
    if (_chunkTimer) {
        [_chunkTimer invalidate];
        _chunkTimer = nil;
    }
    
    [super stopRecording];
}

@end
