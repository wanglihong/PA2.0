//
//  TabBarViewController.h
//  NetworkApplication
//
//  Created by Dennis Yang on 12-11-29.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "CustomTabBar.h"

@interface TabBarViewController : UIViewController<CustomTabBarDelegate> {
    CustomTabBar *tabBar;
    NSArray *tabBarItems;
    NSInteger currentIndex;
}

- (void)setTabBarHidden:(BOOL)hidden;
- (void)setTabBarHidden:(BOOL)hidden withAnimation:(BOOL)anim;

- (void) selectItemAtIndex:(NSInteger)index;

@end
