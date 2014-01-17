//
//  ProcessPhotoViewController.h
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-18.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "ShareViewController.h"
#import "PhotoTitleView.h"

@interface ProcessPhotoViewController : ShareViewController <UIScrollViewDelegate> {
    IBOutlet UIScrollView *_scrollView;
    NSMutableArray *_pages;
    NSArray *_photos;
    
    BOOL _rotating;
    BOOL _dragging;
    int  _pageIndex;
    int  _lastPageIndex;
    
    PhotoTitleView *_titleView;
}

@property (nonatomic, retain) NSArray *photos;
@property (nonatomic, retain) NSMutableArray *pages;
@property int pageIndex;

- (void)setUpScrollViewContent;
- (void)setupScrollViewContentSize;
- (void)moveToPageAtIndex:(NSInteger)index animated:(BOOL)animated;

@end
