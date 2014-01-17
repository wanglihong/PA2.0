//
//  ForgetPasswordViewController.m
//  NetworkApplication
//
//  Created by Dennis Yang on 13-2-26.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import "ForgetPasswordViewController.h"

@interface ForgetPasswordViewController ()

@end

@implementation ForgetPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"找回密码";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    ((UIScrollView *)self.view).contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 1);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submit {
    
    if ([_mobileField.text isEqual:@""] || _mobileField.text.length == 0) {
        [Tools alertWithTitle:@"请输入手机号码"];
        return;
    }
    
    if (_mobileField.text.length != 11) {
        [Tools alertWithTitle:@"请输入正确的手机号码"];
        return;
    }
    
    [__requester setCallback:^(NSDictionary *dic) {
        
        int success = [[dic objectForKey:@"success"] intValue];
        
        switch (success) {
                
            case 0:
            {
                [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"msg"]];
            }
                break;
                
            case 1:
            {
                [SVProgressHUD showSuccessWithStatus:@"密码已发送至您的手机"];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
                
            default:
                break;
        }
        
    }];
    [__requester getPassword:_mobileField.text];
    
    [SVProgressHUD showWithStatus:@"正在提交..."];
}

@end
