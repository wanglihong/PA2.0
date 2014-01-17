//
//  ChangePasswordViewController.m
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-18.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改密码";
    
    UIBarButtonItem *rithtBarItem = [[UIBarButtonItem alloc] initWithTitle:@"提交"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(submit)];
    self.navigationItem.rightBarButtonItem = rithtBarItem;
}

- (void)submit {
    UITextField *oldPassField = [self fieldForRow:0 inSection:0];
    UITextField *newPassField = [self fieldForRow:1 inSection:0];
    UITextField *confirmPassField = [self fieldForRow:2 inSection:0];
    
    if ([oldPassField.text isEqual:@""] || oldPassField.text.length == 0)
        [Tools alertWithTitle:@"请输入旧密码！"];
        
    else if ([newPassField.text isEqual:@""] || newPassField.text.length == 0)
        [Tools alertWithTitle:@"请输入新密码！"];
        
    else if ([confirmPassField.text isEqual:@""] || confirmPassField.text.length == 0)
        [Tools alertWithTitle:@"请再输入一次新密码！"];
        
    else if (![newPassField.text isEqual:confirmPassField.text])
        [Tools alertWithTitle:@"两次输入的密码不一致！"];
        
    else {
        [__requester setCallback:^(NSDictionary *dic) {
            [SVProgressHUD showSuccessWithStatus:@"密码已更改"];
        }];
        [__requester chagePassword:oldPassField.text newPassword:newPassField.text];
        
        [SVProgressHUD showWithStatus:@"正在提交信息..."];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    UILabel *label = (UILabel *)[cell viewWithTag:1000];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 90, 55)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentRight;
        label.font = [UIFont boldSystemFontOfSize:16.0];
        label.tag = 1000;
        [cell addSubview:label];
        [label release];
    }
    label.text = [[Constants chagePasswordTitles] objectAtIndex:indexPath.row];
    
    UITextField *input = (UITextField *)[cell viewWithTag:1001];
    if (!input) {
        input = [[UITextField alloc] initWithFrame:CGRectMake(110, 0, 210, 55)];
        input.borderStyle = UITextBorderStyleNone;
        input.returnKeyType = UIReturnKeyDefault;
        input.secureTextEntry = YES;
        input.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        input.font = [UIFont systemFontOfSize:16.0];
        input.tag = 1001;
        input.delegate = self;
        [cell addSubview:input];
        [input release];
    }
    input.placeholder = [[Constants chagePasswordPlaceholders] objectAtIndex:indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

@end
