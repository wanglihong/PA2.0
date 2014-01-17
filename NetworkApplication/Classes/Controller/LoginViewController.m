//
//  LoginViewController.m
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-13.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "LoginViewController.h"

#import "RegisterViewController.h"

#import "ForgetPasswordViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"登录";
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"取消" style:UIBarButtonItemStylePlain
                                              target:self action:@selector(cancel)];
        self.navigationItem.leftBarButtonItem = leftBarButtonItem;
        [leftBarButtonItem release];
        
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"登录" style:UIBarButtonItemStylePlain
                                              target:self action:@selector(login)];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        [rightBarButtonItem release];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    
    UITextField *nameField = [self fieldForRow:0 inSection:0];
    UITextField *passField = [self fieldForRow:1 inSection:0];
    
    nameField.text = username;
    passField.text = password;
}

- (IBAction)cancel {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)login {
    
    UITextField *nameField = [self fieldForRow:0 inSection:0];
    UITextField *passField = [self fieldForRow:1 inSection:0];
    
    if (nameField.text.length == 0 || [nameField.text isEqual:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号!"];
        
    } else if (passField.text.length == 0 || [passField.text isEqual:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码!"];
        
    } else {
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
                    [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                    
                    [[LocalData data] setCurrentPeople:[__parser peopleWithData:dic]];
                    [[LocalData data] setUSER_LOGIN_STATUS_CHANGED:YES];
                    
                    [[NSUserDefaults standardUserDefaults] setValue:nameField.text forKey:@"username"];
                    [[NSUserDefaults standardUserDefaults] setValue:passField.text forKey:@"password"];
                    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"logout"];
                    
                    [self dismissModalViewControllerAnimated:YES];
                }
                    break;
                    
                default:
                    break;
            }
            
        }];
        [__requester loginWithUserName:nameField.text andPassword:passField.text];
        
        [SVProgressHUD showWithStatus:@"正在登录..."];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    switch (indexPath.section) {
            
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_0"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell_0"];
            }
            
            UILabel *label = (UILabel *)[cell viewWithTag:1000];
            if (!label) {
                label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 55, 55)];
                label.backgroundColor = [UIColor clearColor];
                label.textAlignment = UITextAlignmentRight;
                label.font = [UIFont systemFontOfSize:16.0];
                label.tag = 1000;
                [cell addSubview:label];
                [label release];
            }
            label.text = [[Constants loginTitles] objectAtIndex:indexPath.row];
            
            UITextField *input = (UITextField *)[cell viewWithTag:1001];
            if (!input) {
                input = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, 230, 55)];
                input.borderStyle = UITextBorderStyleNone;
                input.returnKeyType = UIReturnKeyDone;
                input.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                input.font = [UIFont systemFontOfSize:16.0];
                input.tag = 1001;
                input.delegate = self;
                [cell addSubview:input];
                [input release];
            }
            input.placeholder = [[Constants loginPlaceholders] objectAtIndex:indexPath.row];
            if (indexPath.row == 1) input.secureTextEntry = YES;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            break;
        
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_1"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell_1"];
            }
            
            UILabel *label = (UILabel *)[cell viewWithTag:1020];
            if (!label) {
                label = [[UILabel alloc] initWithFrame:CGRectMake(17, 0, 100, 44)];
                label.backgroundColor = [UIColor clearColor];
                label.font = [UIFont systemFontOfSize:14.0];
                label.tag = 1020;
                [cell addSubview:label];
                [label release];
            }
            label.text = [[Constants registerAndForgetPasswordTitles] objectAtIndex:indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            NSLog(@"%@", [[Constants registerAndForgetPasswordTitles] objectAtIndex:indexPath.row]);
        }
            break;
            
        default:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            }
        }
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 55.0f : 44;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            RegisterViewController *controller = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        }
            break;
            
        case 1:
        {
            ForgetPasswordViewController *controller = [[ForgetPasswordViewController alloc] initWithNibName:@"ForgetPasswordViewController" bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UITextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self login];
    return YES;
}

#pragma mark - Private methods

- (UITextField *)fieldForRow:(NSInteger)row inSection:(NSInteger)section {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    UITableViewCell *cell  = [_tableView cellForRowAtIndexPath:indexPath];
    UITextField *textField = (UITextField *)[cell viewWithTag:1001];
    
    return textField;
}

@end
