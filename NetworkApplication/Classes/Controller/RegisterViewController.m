//
//  RegisterViewController.m
//  NetworkApplication
//
//  Created by Dennis Yang on 13-2-18.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@property (nonatomic, retain) NSString *mobile;
@property (nonatomic, retain) NSString *verify;
@property (nonatomic, retain) NSString *pass_1;
@property (nonatomic, retain) NSString *pass_2;
@property (nonatomic, retain) NSString *nickna;

@end

@implementation RegisterViewController

@synthesize mobile, verify, pass_1, pass_2, nickna;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"注册";
        
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]
                                               initWithTitle:@"完成" style:UIBarButtonItemStylePlain
                                               target:self action:@selector(down)];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        [rightBarButtonItem release];
    }
    return self;
}

- (void)dealloc
{
    [mobile release];
    [verify release];
    [pass_1 release];
    [pass_2 release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)down {
    
    if ([mobile isEqual:@""] || mobile.length == 0) {
        [Tools alertWithTitle:@"请输入手机号码！"];
        return;
    }
    
    if ([verify isEqual:@""] || verify.length == 0) {
        [Tools alertWithTitle:@"请输入验证码！"];
        return;
    }
    
    if ([pass_1 isEqual:@""] || pass_1.length == 0) {
        [Tools alertWithTitle:@"请输入密码！"];
        return;
    }
    
    if ([pass_2 isEqual:@""] || pass_2.length == 0) {
        [Tools alertWithTitle:@"请再次输入密码！"];
        return;
    }
    
    if ([nickna isEqual:@""] || nickna.length == 0) {
        [Tools alertWithTitle:@"请输入昵称！"];
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
                [SVProgressHUD showSuccessWithStatus:@"注册成功"];
                [self login];
            }
                break;
                
            default:
                break;
        }
        
    }];
    [__requester registerWithMobile:mobile pass:pass_1 verify:verify];
    
    [SVProgressHUD showWithStatus:@"正在注册..."];
}

- (void)login {
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
                
                [[NSUserDefaults standardUserDefaults] setValue:self.mobile forKey:@"username"];
                [[NSUserDefaults standardUserDefaults] setValue:self.pass_1 forKey:@"password"];
                [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"logout"];
                
                [self dismissModalViewControllerAnimated:YES];
            }
                break;
                
            default:
                break;
        }
        
    }];
    [__requester loginWithUserName:self.mobile andPassword:self.pass_1];
    
    [SVProgressHUD showWithStatus:@"正在登录..."];
}

- (void)code:(id)sender {
    UITextField *mobileField = [self fieldForRow:0 inSection:0];
    
    if ([mobileField.text isEqual:@""] || mobileField.text.length == 0) {
        [Tools alertWithTitle:@"请输入手机号码！"];
        return;
    }
    
    //_getVerifyCodeButton.selected = YES;
    //_getVerifyCodeButton.highlighted = YES;
    //_getVerifyCodeButton.userInteractionEnabled = NO;
    
    //NSDictionary *params = [NSDictionary dictionaryWithObject:mobileField.text forKey:@"mobile"];
    //[[RKClient sharedClient] post:@"/application" params:params delegate:self];
    //[[HUD hud] presentWithText:@"正在发送..."];
    
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
                [SVProgressHUD showSuccessWithStatus:[dic objectForKey:@"msg"]];
                ((UIButton *)sender).userInteractionEnabled = NO;
            }
                break;
                
            default:
                break;
        }
        
    }];
    [__requester getVerifyCode:mobileField.text];
    
    [SVProgressHUD showWithStatus:@"正在获取..."];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [Constants registerTitles].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    switch (indexPath.row) {
            
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_1"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell_1"];
            }
            
            UILabel *label = (UILabel *)[cell viewWithTag:1020];
            if (!label) {
                label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 70, 55)];
                label.backgroundColor = [UIColor clearColor];
                label.textAlignment = UITextAlignmentRight;
                label.font = [UIFont systemFontOfSize:16.0];
                label.tag = 1020;
                [cell addSubview:label];
                [label release];
            }
            label.text = [[Constants registerTitles] objectAtIndex:indexPath.row];
            
            UITextField *input = (UITextField *)[cell viewWithTag:1021];
            if (!input) {
                input = [[UITextField alloc] initWithFrame:CGRectMake(90, 0, 230, 55)];
                input.borderStyle = UITextBorderStyleNone;
                input.returnKeyType = UIReturnKeyDone;
                input.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                input.font = [UIFont systemFontOfSize:16.0];
                input.tag = 1021;
                input.delegate = self;
                [input addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventValueChanged];
                [cell addSubview:input];
                [input release];
            }
            input.placeholder = [[Constants registerPlaceholders] objectAtIndex:indexPath.row];
            
            UIButton *button = (UIButton *)[cell viewWithTag:1022];
            if (!button) {
                button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                button.frame = CGRectMake(210, 9, 90, 37);
                button.tag = 1022;
                [cell addSubview:button];
            }
            [button addTarget:self action:@selector(code:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:@"获取验证码" forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
            break;
            
        default:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_0"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell_0"];
            }
            
            UILabel *label = (UILabel *)[cell viewWithTag:1000];
            if (!label) {
                label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 70, 55)];
                label.backgroundColor = [UIColor clearColor];
                label.textAlignment = UITextAlignmentRight;
                label.font = [UIFont systemFontOfSize:16.0];
                label.tag = 1000;
                [cell addSubview:label];
                [label release];
            }
            label.text = [[Constants registerTitles] objectAtIndex:indexPath.row];
            
            UITextField *input = (UITextField *)[cell viewWithTag:1021];
            if (!input) {
                input = [[UITextField alloc] initWithFrame:CGRectMake(90, 0, 230, 55)];
                input.borderStyle = UITextBorderStyleNone;
                input.returnKeyType = UIReturnKeyDone;
                input.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                input.font = [UIFont systemFontOfSize:16.0];
                input.tag = 1021;
                input.delegate = self;
                [input addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventValueChanged];
                [cell addSubview:input];
                [input release];
            }
            input.placeholder = [[Constants registerPlaceholders] objectAtIndex:indexPath.row];
            if (indexPath.row == 3 || indexPath.row == 4) input.secureTextEntry = YES;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.0f;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)textChanged:(NSNotification *)notification {
    UITextField *textField = [notification object];
    NSIndexPath *indexPath = [_tableView indexPathForCell:(UITableViewCell *)[textField superview]];
    
    switch (indexPath.row) {
        case 0:
            self.mobile = textField.text;
            break;
        case 1:
            self.verify = textField.text;
            break;
        case 2:
            self.pass_1 = textField.text;
            break;
        case 3:
            self.pass_2 = textField.text;
            break;
        case 4:
            self.nickna = textField.text;
            break;
            
        default:
            break;
    }
}

@end
