//
//  Constants.m
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-13.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "Constants.h"

@implementation Constants

+ (NSArray *)loginTitles {
    return [NSArray arrayWithObjects:@"手机号:", @"密码:", nil];
}

+ (NSArray *)loginPlaceholders {
    return [NSArray arrayWithObjects:@"输入您的手机号码", @"登录密码", nil];
}

+ (NSArray *)registerAndForgetPasswordTitles {
    return [NSArray arrayWithObjects:@"快速注册", @"忘记密码？", nil];
}

+ (NSArray *)registerTitles {
    return [NSArray arrayWithObjects:@"手机号码:", @"验证码:", @"登录密码:", @"重复密码:", @"昵称:", nil];
}

+ (NSArray *)registerPlaceholders {
    return [NSArray arrayWithObjects:@"手机号", @"验证码", @"登录密码", @"重复密码", @"昵称", nil];
}

+ (NSArray *)personalSettingNames {
    return [NSArray arrayWithObjects:@"更新帐号资料", @"更改密码", @"绑定微博 分享精彩", @"注销当前帐号", nil];
}

+ (NSArray *)peopleInformationNames {
    return [NSArray arrayWithObjects:@"呢称:", @"真实姓名:", @"所属部门:", @"QQ号码:", @"电子邮箱:", nil];
}

+ (NSArray *)peopleInformationPlaceholders {
    return [NSArray arrayWithObjects:@"您的呢称", @"您的真实姓名", @"您所在部门", @"您的QQ号码", @"您的电子邮箱", nil];
}

+ (NSArray *)chagePasswordTitles {
    return [NSArray arrayWithObjects:@"旧密码:", @"新密码:", @"确认新密码:", nil];
}

+ (NSArray *)chagePasswordPlaceholders {
    return [NSArray arrayWithObjects:@"输入旧密码", @"输入新密码", @"再次输入新密码", nil];
}

@end
