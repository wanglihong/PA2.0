//
//  Image.m
//  Red-PA
//
//  Created by Dennis Yang on 12-9-11.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "Image.h"

@implementation Image

@synthesize imageId = _imageId;
@synthesize imageDate = _imageDate;
@synthesize imageVoiceId = _imageVoiceId;
@synthesize people = _people;
@synthesize hasSupported = _hasSupported;
@synthesize supportCount = _supportCount;

@synthesize image_180;
@synthesize image_360;
@synthesize image_720;

- (void)set_imageDate:(NSString *)imageDate
{
    if (imageDate != _imageDate) {
        
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'Z";
        NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@GMT+00:00", imageDate]];
        
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        
        NSString *formattedString = [formatter stringFromDate:date];
        [formatter release];
        
        [_imageDate release];
        _imageDate = [formattedString retain];
    }
}

- (void)dealloc {
    [_imageId release];
    [_imageDate release];
    [_imageVoiceId release];
    [_people release];
    [image_180 release];
    [image_360 release];
    [image_720 release];
    
    [super dealloc];
}

@end
