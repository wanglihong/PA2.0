//
//  PeopleInfoView.m
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-12.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "PeopleInfoView.h"
#import "AppDelegate.h"

@implementation PeopleInfoView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
        contentView.backgroundColor = RGBA(0, 0, 0, .85);
        contentView.center = self.center;
        [self addSubview:contentView];
        [contentView release];
        
        iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 93, 93)];
        [contentView addSubview:iconView];
        [iconView release];
        
        nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 240, 20)];
        nickNameLabel.backgroundColor = [UIColor clearColor];
        nickNameLabel.textColor = [UIColor whiteColor];
        nickNameLabel.font = [UIFont boldSystemFontOfSize:18.0];
        [contentView addSubview:nickNameLabel];
        [nickNameLabel release];
        
        realNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 40, 240, 15)];
        realNameLabel.backgroundColor = [UIColor clearColor];
        realNameLabel.textColor = [UIColor whiteColor];
        realNameLabel.font = [UIFont systemFontOfSize:15.0];
        [contentView addSubview:realNameLabel];
        [realNameLabel release];
        
        departmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 60, 240, 15)];
        departmentLabel.backgroundColor = [UIColor clearColor];
        departmentLabel.textColor = [UIColor whiteColor];
        departmentLabel.font = [UIFont systemFontOfSize:15.0];
        [contentView addSubview:departmentLabel];
        [departmentLabel release];
        
        qqLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 80, 240, 15)];
        qqLabel.backgroundColor = [UIColor clearColor];
        qqLabel.textColor = [UIColor whiteColor];
        qqLabel.font = [UIFont systemFontOfSize:15.0];
        [contentView addSubview:qqLabel];
        [qqLabel release];
        
        emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 100, 240, 15)];
        emailLabel.backgroundColor = [UIColor clearColor];
        emailLabel.textColor = [UIColor whiteColor];
        emailLabel.font = [UIFont systemFontOfSize:15.0];
        [contentView addSubview:emailLabel];
        [emailLabel release];
        
        description = [[UITextView alloc] initWithFrame:CGRectMake(0, 130, 320, 70)];
        description.backgroundColor = [UIColor clearColor];
        description.textColor = [UIColor whiteColor];
        description.font = [UIFont systemFontOfSize:15.0];
        description.userInteractionEnabled = NO;
        [contentView addSubview:description];
        [description release];
        
        UIImageView *shadows_top = [[UIImageView alloc] initWithFrame:CGRectMake(0, -5, contentView.frame.size.width, 5)];
        shadows_top.image = [UIImage imageNamed:@"shadows_bottom.png"];
        [contentView addSubview:shadows_top];
        [shadows_top release];
        
        UIImageView *shadows_bottom = [[UIImageView alloc] initWithFrame:CGRectMake(0, contentView.frame.size.height, contentView.frame.size.width, 5)];
        shadows_bottom.image = [UIImage imageNamed:@"shadows_top.png"];
        [contentView addSubview:shadows_bottom];
        [shadows_bottom release];
        
        self.backgroundColor = RGBA(0, 0, 0, .25);
        self.alpha = 0;
    }
    return self;
}

static PeopleInfoView *_instance = nil;

+ (PeopleInfoView *)sharedView {
    
    @synchronized(self){
		if (!_instance){
			_instance = [[PeopleInfoView alloc] initWithFrame:[UIScreen mainScreen].bounds];
		}
	}
	
	return _instance;
}

- (void)setInfo:(People *)people {
    
    [iconView setImageWithURL:[NSURL URLWithString:IMAGE(people.peopleHeaderURL)]];
    nickNameLabel.text = people.peopleNickName;
    realNameLabel.text = COMBINE(@"真名: ", people.peopleRealName);
    departmentLabel.text = COMBINE(@"部门: ", people.peopleDepartment);
    qqLabel.text = COMBINE(@"QQ号: ", people.peopleQQ);
    emailLabel.text = COMBINE(@"Email: ", people.peopleEmail);
    description.text = people.peopleInformation;
}

- (void)showPeopleInfo:(People *)people atPosition:(CGRect)frame {
    
    [self setInfo:people];
    
    [[[UIApplication sharedApplication].delegate window] addSubview:self];
    
    // 此时 frame 是屏幕的坐标系坐标
    // 将 frame 转换成 contentView 坐标系坐标
    iconView.frame = CGRectMake(frame.origin.x, frame.origin.y - contentView.frame.origin.y, frame.size.width, frame.size.height);
    position = iconView.frame;
    [UIView animateWithDuration:.5
                     animations:^{
                         self.alpha = 1;
                         iconView.frame = CGRectMake(10, 40, 60, 60);
                         [iconView.layer setTransform:CATransform3DRotate(iconView.layer.transform, M_PI, 0, 1, 0)];
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [UIView animateWithDuration:.25
                     animations:^{
                         self.alpha = 0;
                         iconView.frame = position;
                         [iconView.layer setTransform:CATransform3DRotate(iconView.layer.transform, -M_PI, 0, 1, 0)];
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

@end
