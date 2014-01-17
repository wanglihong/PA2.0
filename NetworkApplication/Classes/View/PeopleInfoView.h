//
//  PeopleInfoView.h
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-12.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface PeopleInfoView : UIView {
    UIView *contentView;
    UIImageView *iconView;
    UILabel *nickNameLabel;
    UILabel *realNameLabel;
    UILabel *departmentLabel;
    UILabel *qqLabel;
    UILabel *emailLabel;
    UITextView *description;
    
    CGRect position;
}

+ (PeopleInfoView *)sharedView;
- (void)showPeopleInfo:(People *)people atPosition:(CGRect)frame;

@end
