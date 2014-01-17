//
//  AboutViewController.m
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-17.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "AboutViewController.h"
#import "TabBarViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height + 1);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [TABBAR_VIEW_CONTROLLER setTabBarHidden:YES];
}

@end
