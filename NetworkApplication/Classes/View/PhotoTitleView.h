//
//  PhotoTitleView.h
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-24.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoTitleView : UIView {
    UILabel *titleLabel;
    UILabel *descrLabel;
}

@property (nonatomic, assign) UILabel *titleLabel;
@property (nonatomic, assign) UILabel *descrLabel;

@end
