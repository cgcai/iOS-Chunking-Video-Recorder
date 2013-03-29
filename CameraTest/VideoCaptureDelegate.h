//
//  VideoCaptureDelegate.h
//  Channely
//
//  Created by Camillus Gerard Cai on 14/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ChunkedVideoCapture;

@protocol VideoCaptureDelegate <NSObject>
@required
- (void) videoCapture:(ChunkedVideoCapture *)sender didStartRecordingToDirectory:(NSString *)path;
- (void) videoCapture:(ChunkedVideoCapture *)sender didStopRecordingToDirectory:(NSString *)path;
- (void) videoCapture:(ChunkedVideoCapture *)sender didChunkVideoInDirectory:(NSString *)path;

@end
