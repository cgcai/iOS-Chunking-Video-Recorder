//
//  HLSEventPlaylistHelper.h
//  CameraTest
//
//  Created by Camillus Gerard Cai on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLSEventPlaylistHelper : NSObject
- (id) initWithFileURL:(NSURL *)url;
- (void) beginPlaylistWithTargetInterval:(NSUInteger)period;
- (void) appendItem:(NSString *)path withDuration:(NSUInteger)length;
- (void) appendItem:(NSString *)path withDuration:(NSUInteger)length withTitle:(NSString *)title;
- (void) endPlaylist;

@end
