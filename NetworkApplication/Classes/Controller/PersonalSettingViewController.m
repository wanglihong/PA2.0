//
//  PersonalSettingViewController.m
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-17.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "PersonalSettingViewController.h"
#import "TabBarViewController.h"
#import "UpdatePeopleInformationViewController.h"
#import "ChangePasswordViewController.h"

@interface PersonalSettingViewController ()

@end

@implementation PersonalSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人设置";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [TABBAR_VIEW_CONTROLLER setTabBarHidden:YES];
}

- (void)logout {
    [__requester setCallback:^(NSDictionary *dic) {
        [SVProgressHUD showSuccessWithStatus:@"注销成功"];
        [[LocalData data] setCurrentPeople:nil];
        [[LocalData data] setUSER_LOGIN_STATUS_CHANGED:YES];
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"logout"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [__requester logout];
    
    [SVProgressHUD showWithStatus:@"正在注销..."];
}

- (void)bindWeibo {
    // 微博Engine
    if (!engine) {
        engine = [[WBEngine alloc] initWithAppKey:kWBSDKDemoAppKey appSecret:kWBSDKDemoAppSecret];
        [engine setRootViewController:self];
        [engine setDelegate:self];
        [engine setRedirectURI:kWBRedirectURI];
        [engine setIsUserExclusive:NO];
    }
    
    if ([engine isLoggedIn] && ![engine isAuthorizeExpired]) 
        [Tools alertWithTitle:@"您已绑定过微博"];
    
    else 
        [engine logIn];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
    }
    
    cell.textLabel.text = [[Constants personalSettingNames] objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.0f;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
            
        case 0:
        {
            UpdatePeopleInformationViewController *viewController =
            [[UpdatePeopleInformationViewController alloc] initWithNibName:@"UpdatePeopleInformationViewController" bundle:nil];
            [self.navigationController pushViewController:viewController animated:YES];
            [viewController release];
        }
            break;
            
        case 1:
        {
            ChangePasswordViewController *viewController =
            [[ChangePasswordViewController alloc] initWithNibName:@"ChangePasswordViewController" bundle:nil];
            [self.navigationController pushViewController:viewController animated:YES];
            [viewController release];
        }
            break;
            
        case 2:
        {
            [self bindWeibo];
        }
            break;
            
        case 3:
        {
            [self logout];
        }
            break;
            
        default:
            break;
    }
}

- (void)dealloc {
    [super dealloc];
    
    if (engine) {
        [engine setDelegate:nil];
        [engine release];
    }
}

@end
