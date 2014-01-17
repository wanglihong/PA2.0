//
//  LoadingViewController.h
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-14.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "NetworkViewController.h"

@interface LoadingViewController : NetworkViewController {
    UIImageView *_bg;
    UILabel *_prompt;
    
    RKReachabilityObserver *_observer;
}

@end
