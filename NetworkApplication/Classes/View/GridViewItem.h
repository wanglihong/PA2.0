//
//  GridViewItem.h
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-4.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@class GridViewItem;

@protocol GridViewItemDelegate <NSObject>
@optional
- (void)gridViewItem:(GridViewItem *)gridViewItem didSelectedItemAtIndex:(NSInteger)index;
@end

@interface GridViewItem : UIView {
    UIImageView *shadow;
    UIImageView *imageView;
    
    id<GridViewItemDelegate> delegate;
    NSInteger index;
}

@property (nonatomic, retain) UIImageView *shadow;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, assign) id<GridViewItemDelegate> delegate;
@property NSInteger index;

@end
