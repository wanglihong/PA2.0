//
//  Comment.h
//  Red-PA
//
//  Created by Dennis Yang on 12-11-8.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "People.h"

@interface Comment : NSObject
{
    People *_people;
    
    NSString *_date;
    NSString *_content;
    NSString *_imageId;
    NSString *_voiceId;
    NSString *_commentId;
    NSInteger _length;
}

@property (nonatomic, retain) People *people;

@property (nonatomic, retain, setter = set_date:) NSString *date;
@property (nonatomic, retain, getter = get_content) NSString *content;
@property (nonatomic, retain) NSString *imageId;
@property (nonatomic, retain) NSString *voiceId;
@property (nonatomic, retain) NSString *commentId;
@property (nonatomic) NSInteger length;

- (void)set_date:(NSString *)date;
- (NSString *)get_content;

@end
