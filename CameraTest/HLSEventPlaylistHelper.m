//
//  HLSEventPlaylistHelper.m
//  CameraTest
//
//  Created by Camillus Gerard Cai on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "HLSEventPlaylistHelper.h"

NSString *const cPlaylistHeaderFormat = @"#EXTM3U\n#EXT-X-PLAYLIST-TYPE:EVENT\n#EXT-X-TARGETDURATION:%d\n#EXT-X-MEDIA-SEQUENCE:%d\n";
NSString *const cPlaylistMediaItemFormat = @"#EXTINF:%d,%@\n%@\n";
NSString *const cPlaylistTrailerFormat = @"#EXT-X-ENDLIST";
NSUInteger const cDefaultSequenceNumber = 0;

@interface HLSEventPlaylistHelper ()
// Internal.
@property (strong) NSURL * _fileName;
@property (atomic) NSUInteger _targetInterval;
@property (strong) NSMutableString *_buffer;

- (void) writeBufferToFile;

@end

@implementation HLSEventPlaylistHelper
// Internal.
@synthesize _fileName;
@synthesize _targetInterval;
@synthesize _buffer;

- (id) initWithFileURL:(NSURL *)url {
    if (self = [super init]) {
        _fileName = url;
        _buffer = nil;
    }
    return self;
}

- (void) beginPlaylistWithTargetInterval:(NSUInteger)period {
    _targetInterval = period;
    _buffer = [[NSMutableString alloc] init];
    
    [_buffer appendFormat:cPlaylistHeaderFormat, _targetInterval, cDefaultSequenceNumber];
}

- (void) appendItem:(NSString *)path withDuration:(NSUInteger)length {    
    [self appendItem:path withDuration:length withTitle:@""];
}

- (void) appendItem:(NSString *)path withDuration:(NSUInteger)length withTitle:(NSString *)title {
    if (!_buffer) {
        return;
    }
    
    [_buffer appendFormat:cPlaylistMediaItemFormat, length, title, path];
}

- (void) endPlaylist {
    if (!_buffer) {
        return;
    }
    
    [_buffer appendString:cPlaylistTrailerFormat];
    [self writeBufferToFile];
}

// If the file exists, it is truncated and overwritten.
- (void) writeBufferToFile {
    if (!_buffer) {
        return;
    }
    
    // Debug:
    NSLog(@"%@", _buffer);
    
    NSData *data = [_buffer dataUsingEncoding:NSUTF8StringEncoding];
    [data writeToURL:_fileName atomically:YES];
}

@end
