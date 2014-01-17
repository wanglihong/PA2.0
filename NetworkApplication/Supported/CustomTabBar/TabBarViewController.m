//
//  TabBarViewController.m
//  NetworkApplication
//
//  Created by Dennis Yang on 12-11-29.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "TabBarViewController.h"
#import "DetailViewController.h"
#import "MemberViewController.h"
#import "CameraViewController.h"
#import "PhotoViewController.h"
#import "SettingViewController.h"
#import "HomeViewController.h"
#import "PartyViewController.h"

#define SELECTED_VIEW_CONTROLLER_TAG 98456345
#define TAB_BAR_HEIGHT 44

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (id)init {
    
    if (self == [super init]) {
        
        UIViewController *v1 = [[[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil] autorelease];
        UIViewController *v2 = [[[MemberViewController alloc] initWithNibName:@"MemberViewController" bundle:nil] autorelease];
        UIViewController *v3 = [[[CameraViewController alloc] initWithNibName:@"CameraViewController" bundle:nil] autorelease];
        UIViewController *v4 = [[[PhotoViewController alloc] initWithNibName:@"PhotoViewController" bundle:nil] autorelease];
        UIViewController *v5 = [[[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil] autorelease];
        
        UINavigationController *n1 = [[[UINavigationController alloc] initWithRootViewController:v1] autorelease];
        UINavigationController *n2 = [[[UINavigationController alloc] initWithRootViewController:v2] autorelease];
        UINavigationController *n3 = [[[UINavigationController alloc] initWithRootViewController:v3] autorelease];
        UINavigationController *n4 = [[[UINavigationController alloc] initWithRootViewController:v4] autorelease];
        UINavigationController *n5 = [[[UINavigationController alloc] initWithRootViewController:v5] autorelease];
        
        NSDictionary *d1 = [NSDictionary dictionaryWithObjectsAndKeys:@"home.png",             @"image", n1, @"viewController", nil];
        NSDictionary *d2 = [NSDictionary dictionaryWithObjectsAndKeys:@"friend_normal.png",    @"image", n2, @"viewController", nil];
        NSDictionary *d3 = [NSDictionary dictionaryWithObjectsAndKeys:@"camera_normal.png",    @"image", n3, @"viewController", nil];
        NSDictionary *d4 = [NSDictionary dictionaryWithObjectsAndKeys:@"scene_normal.png",     @"image", n4, @"viewController", nil];
        NSDictionary *d5 = [NSDictionary dictionaryWithObjectsAndKeys:@"settings_normal.png",  @"image", n5, @"viewController", nil];
        
        tabBarItems = [[NSArray arrayWithObjects:d1, d2, d3, d4, d5, nil] retain];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tabBar = [[CustomTabBar alloc] initWithItemCount:tabBarItems.count
                                            itemSize:CGSizeMake(self.view.frame.size.width/tabBarItems.count, TAB_BAR_HEIGHT)
                                                 tag:0 delegate:self];
    tabBar.frame = CGRectMake(0, self.view.frame.size.height - TAB_BAR_HEIGHT, self.view.frame.size.width, TAB_BAR_HEIGHT);
    [self.view addSubview:tabBar];
    
    [tabBar selectItemAtIndex:0];
    [self touchDownAtItemAtIndex:0];
    
    HomeViewController *controller = [[[HomeViewController alloc] init] autorelease];
    [controller.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:controller.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(partyChanged:)
                                                 name:@"PartyChanged" object:nil];
}

- (void)partyChanged:(NSNotification *)notification {
    NSDictionary* data = [tabBarItems objectAtIndex:currentIndex];
    UINavigationController *navController = (UINavigationController *)([data objectForKey:@"viewController"]);
    PartyViewController* viewController = (PartyViewController *)[navController visibleViewController];
    [viewController handlePartyChanged];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)dealloc {
    [tabBarItems release];
    [tabBar release];
    [super dealloc];
}

#pragma mark CustomTabBarDelegate

- (UIImage*)imageFor:(CustomTabBar*)tabBar atIndex:(NSUInteger)itemIndex {
    NSDictionary *tabBarItem = [tabBarItems objectAtIndex:itemIndex];
    return [UIImage imageNamed:[tabBarItem objectForKey:@"image"]];
}

- (UIImage*)backgroundImage {
    CGFloat width = self.view.frame.size.width;
    UIImage* topImage = [UIImage imageNamed:@"TabBarGradient.png"];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, TAB_BAR_HEIGHT), NO, 0.0);
    
    UIImage* stretchedTopImage = [topImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    [stretchedTopImage drawInRect:CGRectMake(0, 0, width, topImage.size.height)];
    
    [[UIColor redColor] set];
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, topImage.size.height, width, TAB_BAR_HEIGHT - topImage.size.height));
    
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

- (UIImage*)selectedItemBackgroundImage {
    return [UIImage imageNamed:@"TabBarItemSelectedBackground.png"];
}

- (UIImage*)glowImage {
    UIImage* tabBarGlow = [UIImage imageNamed:@"TabBarGlow.png"];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(tabBarGlow.size.width, tabBarGlow.size.height-4.0), NO, 0.0);
    
    [tabBarGlow drawAtPoint:CGPointZero];
    
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

- (UIImage*)selectedItemImage {
    CGSize tabBarItemSize = CGSizeMake(self.view.frame.size.width/tabBarItems.count, TAB_BAR_HEIGHT);
    UIGraphicsBeginImageContextWithOptions(tabBarItemSize, NO, 0.0);
    
    [[[UIImage imageNamed:@"TabBarSelection.png"] stretchableImageWithLeftCapWidth:4.0 topCapHeight:0] drawInRect:CGRectMake(0, 4.0, tabBarItemSize.width, tabBarItemSize.height-4.0)];
    
    UIImage* selectedItemImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return selectedItemImage;
}

- (UIImage*)tabBarArrowImage {
    return nil;//[UIImage imageNamed:@"TabBarNipple.png"];
}

- (void)touchDownAtItemAtIndex:(NSUInteger)itemIndex
{
    currentIndex = itemIndex;
    
    UIView* currentView = [self.view viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];
    [currentView removeFromSuperview];
    
    NSDictionary* data = [tabBarItems objectAtIndex:itemIndex];
    UIViewController* viewController = [data objectForKey:@"viewController"];
    
    viewController.view.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height - TAB_BAR_HEIGHT);
    
    viewController.view.tag = SELECTED_VIEW_CONTROLLER_TAG;
    
    [self.view insertSubview:viewController.view belowSubview:tabBar];
    
    [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(addGlowTimerFireMethod:) userInfo:[NSNumber numberWithInteger:itemIndex] repeats:NO];
    
}

- (void)addGlowTimerFireMethod:(NSTimer*)theTimer
{
    for (NSUInteger i = 0 ; i < tabBarItems.count ; i++) {
        [tabBar removeGlowAtIndex:i];
    }
    
    [tabBar glowItemAtIndex:[[theTimer userInfo] integerValue]];
}

- (void)setTabBarHidden:(BOOL)hidden {
    [UIView animateWithDuration:.25
                     animations:^{
                         NSDictionary* data = [tabBarItems objectAtIndex:currentIndex];
                         UIViewController* viewController = [data objectForKey:@"viewController"];
                         
                         viewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + ( hidden ? 0 : -TAB_BAR_HEIGHT ) );
                         tabBar.frame = CGRectMake(0, self.view.frame.size.height + ( hidden ? 0 : -TAB_BAR_HEIGHT ), self.view.frame.size.width, tabBar.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)setTabBarHidden:(BOOL)hidden withAnimation:(BOOL)anim {
    if (anim) {
        [self setTabBarHidden:hidden];
    } else {
        NSDictionary* data = [tabBarItems objectAtIndex:currentIndex];
        UIViewController* viewController = [data objectForKey:@"viewController"];
        viewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + ( hidden ? 0 : -TAB_BAR_HEIGHT ) );
        tabBar.frame = CGRectMake(0, self.view.frame.size.height + ( hidden ? 0 : -TAB_BAR_HEIGHT ), self.view.frame.size.width, tabBar.frame.size.height);
    }
}

- (void) selectItemAtIndex:(NSInteger)index {
    [tabBar selectItemAtIndex:index];
    [self touchDownAtItemAtIndex:index];
}

@end
