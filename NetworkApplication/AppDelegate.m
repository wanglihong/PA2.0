//
//  AppDelegate.m
//  NetworkApplication
//
//  Created by Dennis Yang on 12-10-29.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "AppDelegate.h"

#import "TabBarViewController.h"
#import "LoadingViewController.h"

@implementation AppDelegate

- (void)dealloc {
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (void)setting {
    NSDictionary *defaultValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                   nil,  @"username",
                                   nil,  @"password",
                                   nil,  @"homeFirst",
                                   nil,  @"detlFirst",
                                   nil,  @"logout",
                                   nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window                    = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.viewController            = [[[LoadingViewController alloc] init] autorelease];
    self.window.rootViewController = self.viewController;
    
    [self setting];
    [self showLoading];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)showLoading {
    
}

- (void)didFinishLoading {
    self.viewController            = [[[TabBarViewController alloc] init] autorelease];
    self.window.rootViewController = self.viewController;
}

@end
