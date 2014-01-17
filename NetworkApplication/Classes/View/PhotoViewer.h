//
//  PhotoViewer.h
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-13.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewer : UIScrollView <UIScrollViewDelegate> {
    NSMutableArray *_pages;
    NSArray *_photos;
    
    BOOL _rotating;
    BOOL _dragging;
    int  _pageIndex;
    int  _lastPageIndex;
}

@property (nonatomic, retain) NSArray *photos;
@property (nonatomic, retain) NSMutableArray *pages;
@property int pageIndex;

- (void)setUpScrollViewContent;
- (void)setupScrollViewContentSize;
- (void)moveToPageAtIndex:(NSInteger)index animated:(BOOL)animated;

@end
