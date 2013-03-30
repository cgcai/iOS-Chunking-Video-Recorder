//
//  HLSEventProducerDelegate.h
//  CameraTest
//
//  Created by Camillus Gerard Cai on 30/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLSEventProducer.h"

@class HLSEventProducer;

@protocol HLSEventProducerDelegate <NSObject>
// Informational.
- (NSInteger) newRecordingId;

// Callbacks.
- (void) eventProducer:(HLSEventProducer *)producer hasNewPlaylist:(NSString *)playlist firstChunk:(NSString *)chunk duration:(NSTimeInterval)duration;
- (void) eventProducer:(HLSEventProducer *)producer updatedPlaylist:(NSString *)playlist newChunk:(NSString *)chunk duration:(NSTimeInterval)duration;
- (void) eventProducer:(HLSEventProducer *)producer endedRecordingToPlaylist:(NSString *)playlist;

@end
