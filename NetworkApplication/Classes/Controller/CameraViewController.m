//
//  CameraViewController.m
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-10.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "CameraViewController.h"

#import "CameraImageHelper.h"

#import "CustomizedCameraViewController.h"

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CustomizedCameraViewController *controller = [[CustomizedCameraViewController alloc] initWithNibName:@"CustomizedCameraViewController" bundle:nil];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [navController setNavigationBarHidden:YES];
    [TABBAR_VIEW_CONTROLLER presentModalViewController:navController animated:NO];
    
    [controller release];
    [navController release];
}

- (void)dealloc {
    [super dealloc];
}

@end
