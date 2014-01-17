//
//  LoadingViewController.m
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-14.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "LoadingViewController.h"
#import "AppDelegate.h"

@interface LoadingViewController ()

@end

@implementation LoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (__IPHONE5) 
        _bg = [[UIImageView alloc] initWithImage:LOCAL_IMAGE(@"Default-568h@2x", @"png")];
    else 
        _bg = [[UIImageView alloc] initWithImage:LOCAL_IMAGE(@"Default", @"png")];
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_bg];
    [_bg release];
    
    _prompt = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 80, self.view.bounds.size.width, 21)];
    _prompt.backgroundColor = [UIColor clearColor];
    _prompt.textAlignment = UITextAlignmentCenter;
    _prompt.textColor = [UIColor whiteColor];
    [self.view addSubview:_prompt];
    [_prompt release];
    
    _observer = [[RKReachabilityObserver alloc] initWithHost:_host];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:RKReachabilityDidChangeNotification
                                               object:_observer];
}

- (void)reachabilityChanged:(NSNotification *)notification {
    RKReachabilityObserver *observer = (RKReachabilityObserver *)[notification object];
    
    if ([observer isNetworkReachable]) {
        _prompt.text = @"Loading...";
        [self autoLogin];
        
    } else {
        _prompt.text = @"无网络连接...";
    }
}

- (void)autoLogin {
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    NSString *logout   = [[NSUserDefaults standardUserDefaults] objectForKey:@"logout"];
    
    if (logout==nil && username && password) {
        [__requester setCallback:^(NSDictionary *dic) {
            [[LocalData data] setCurrentPeople:[__parser peopleWithData:dic]];
            [APP_DELEGATE didFinishLoading];
        }];
        [__requester loginWithUserName:username andPassword:password];
        
    } else {
        [APP_DELEGATE didFinishLoading];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_observer release];
    
    [super dealloc];
}

@end
