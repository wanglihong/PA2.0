//
//  Comment.m
//  Red-PA
//
//  Created by Dennis Yang on 12-11-8.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "Comment.h"

@implementation Comment

@synthesize people = _people;

@synthesize date = _date;
@synthesize content = _content;
@synthesize imageId = _imageId;
@synthesize voiceId = _voiceId;
@synthesize commentId = _commentId;
@synthesize length = _length;

- (void)set_date:(NSString *)date
{
    if (date != _date) {
        
        NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'Z";
        NSDate *__date = [formatter dateFromString:[NSString stringWithFormat:@"%@GMT+00:00", date]];
        /*
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        
        NSString *formattedString = [formatter stringFromDate:__date];
        [formatter release];
        
        [_date release];
        _date = [formattedString retain];
        */
        NSTimeInterval val = [__date timeIntervalSinceNow];
        int time = fabs(val);
        
        if ( time < 60 ) {
            _date = [[NSString stringWithFormat:@"%d秒前", time] retain];
            
        } else if ( time < (60*60) ) {
            _date = [[NSString stringWithFormat:@"%d分钟前", time/(60)] retain];
            
        } else if ( time < (60*60*24) ) {
            _date = [[NSString stringWithFormat:@"%d小时前", time/(60*60)] retain];
            
        } else if ( time < (60*60*24*30) ) {
            _date = [[NSString stringWithFormat:@"%d天前", time/(60*60*24)] retain];
            
        } else if ( time < (60*60*24*30*12) ) {
            _date = [[NSString stringWithFormat:@"%d个月前", time/(60*60*24*30)] retain];
            
        } else {
            _date = [[NSString stringWithFormat:@"%d年前", time/(60*60*24*30*12)] retain];
            
        }
    }
}

- (NSString *)get_content
{
    if (nil != _content && ![@"(null)" isEqual:_content] && ![[NSNull null] isEqual:_content])
        return _content;
    else
        return @"";
}

- (void)dealloc
{
    [_people release];
    
    [_date release];
    [_content release];
    [_imageId release];
    [_voiceId release];
    [_commentId release];
    
    [super dealloc];
}

@end
