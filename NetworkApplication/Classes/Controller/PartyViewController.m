//
//  PartyViewController.m
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-5.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "PartyViewController.h"
#import "LoginViewController.h"
#import "HomeViewController.h"

@interface PartyViewController ()

@end

@implementation PartyViewController

@synthesize party;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.party = [LocalData data].currentParty;
    }
    return self;
}

- (id)init {
    if (self == [super init]) {
        self.party = [LocalData data].currentParty;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTintColor:[UIColor redColor]];
    
    UIImageView *shadow = (UIImageView *)[self.navigationController.navigationBar viewWithTag:9999];
    if (!shadow) {
        shadow = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 5)] autorelease];
        shadow.tag = 9999;
        shadow.image = [UIImage imageNamed:@"shadows_top.png"];
        [self.navigationController.navigationBar addSubview:shadow];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ( [self isPartyChanged] == YES ) {
        self.party = [[LocalData data] currentParty];
        [self handlePartyChanged];
    }
}

- (BOOL)isPartyChanged {
    return [self.party.partyId isEqual:[[LocalData data] currentParty].partyId] ? NO : YES ;
}

- (void)handlePartyChanged {
    self.party = [LocalData data].currentParty;
    // PA图不需要再提示更新
    [LocalData data].HAVE_NEW_PHOTO = NO;
}

- (void)presentLoginViewController {
    LoginViewController *viewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *nac = [[UINavigationController alloc] initWithRootViewController:viewController];
    nac.navigationBar.tintColor = [UIColor redColor];
    [ROOT_VIEW_CONTROLLER presentModalViewController:nac animated:YES];
    [viewController release];
    [nac release];
}

- (void)setSwipEnable:(BOOL)swip {
    if (swip) {
        UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
        gestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:gestureRecognizer];
        [gestureRecognizer release];
    }
}

- (void)swipe:(UISwipeGestureRecognizer *)recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self presentGridViewControllerWithTimeInterVal];
    }
}

- (void)presentGridViewControllerWithTimeInterVal {
    
    HomeViewController *controller = [[[HomeViewController alloc] init] autorelease];
    [((UIView *)TABBAR_VIEW_CONTROLLER.view) addSubview:controller.view];
    [controller.view setFrame:CGRectMake(-controller.view.frame.size.width, 0,
                                         controller.view.frame.size.width, controller.view.frame.size.height)];
    
    [UIView animateWithDuration:.35
                     animations:^{
                         [controller.view setFrame:CGRectMake(0, 0, controller.view.frame.size.width,
                                                              controller.view.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)dealloc {
    [party release];
    [super dealloc];
}

@end
