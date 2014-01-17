//
//  NetworkViewController.m
//  NetworkApplication
//
//  Created by Dennis Yang on 12-10-29.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "NetworkViewController.h"

@interface NetworkViewController ()

@end

@implementation NetworkViewController

- (id)init {
    self = [super init];
    if (self) {
        _requester = [LJRequester sharedRequester];
        _parser = [LJParser sharedParser];
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)dealloc {
    [super dealloc];
}

@end
