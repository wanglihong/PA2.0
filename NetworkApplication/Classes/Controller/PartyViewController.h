//
//  PartyViewController.h
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-5.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "NetworkViewController.h"
#import "TabBarViewController.h"
#import "GMGridView.h"
#import "Party.h"

@interface PartyViewController : NetworkViewController

@property (nonatomic, retain) Party *party;

- (BOOL)isPartyChanged;
- (void)handlePartyChanged;
- (void)presentLoginViewController;
- (void)setSwipEnable:(BOOL)swip;

@end
