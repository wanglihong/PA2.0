//
//  SettingViewController.m
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-10.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "SettingViewController.h"
#import "PersonalSettingViewController.h"
#import "AboutViewController.h"
#import "TabBarViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [TABBAR_VIEW_CONTROLLER setTabBarHidden:NO];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
    }
    
    switch (indexPath.section) {
            
        case 0: {
            cell.textLabel.text = @"个人设置";
            cell.detailTextLabel.text = @"更新资料、绑定微博等设置";
        }
            break;
            
        case 1: {
            cell.textLabel.text = @"关于";
            cell.detailTextLabel.text = @"v2.0.0";
        }
            break;
            
        default:
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
    
    switch (indexPath.section) {
            
        case 0:
        {
            if ([LocalData data].currentPeople == nil) {
                [self presentLoginViewController];
            } else {
                PersonalSettingViewController *viewController = [[PersonalSettingViewController alloc] initWithNibName:@"PersonalSettingViewController" bundle:nil];
                [self.navigationController pushViewController:viewController animated:YES];
                [viewController release];
            }
        }
            break;
            
        case 1:
        {
            AboutViewController *viewController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
            [self.navigationController pushViewController:viewController animated:YES];
            [viewController release];
        }
            break;
            
        default:
            break;
    }
}

@end
