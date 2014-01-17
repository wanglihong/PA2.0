//
//  HomeViewController.h
//  NetworkApplication
//
//  Created by Dennis Yang on 12-10-29.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "NetworkViewController.h"
#import "GridViewItem.h"

@interface HomeViewController : NetworkViewController <UIScrollViewDelegate, GridViewItemDelegate> {
    UIScrollView *_scrollView;
    UIImageView  *_background;
    NSMutableArray *_parties;
}

@property (nonatomic, retain) NSMutableArray *parties;

@end
