//
//  PhotoTitleView.m
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-24.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "PhotoTitleView.h"

@implementation PhotoTitleView

@synthesize titleLabel;
@synthesize descrLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height/2)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextColor:[UIColor whiteColor]];
        //[titleLabel setFont:[UIFont systemFontOfSize:14]];
        [titleLabel setTextAlignment:UITextAlignmentCenter];
        [self addSubview:titleLabel];
        [titleLabel release];
        
        descrLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height/2, frame.size.width, frame.size.height/2)];
        [descrLabel setBackgroundColor:[UIColor clearColor]];
        [descrLabel setTextColor:[UIColor whiteColor]];
        [descrLabel setFont:[UIFont systemFontOfSize:13]];
        [descrLabel setTextAlignment:UITextAlignmentCenter];
        [self addSubview:descrLabel];
        [descrLabel release];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
