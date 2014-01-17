//
//  MemberViewController.h
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-10.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "PartyViewController.h"

@interface MemberViewController : PartyViewController
                                <GMGridViewDataSource,
                                GMGridViewSortingDelegate,
                                GMGridViewActionDelegate> {
    IBOutlet __gm_weak GMGridView *_gmGridView;
    NSMutableArray *_data;
    NSInteger _total;
    NSInteger _lastDeleteItemIndexAsked;
}

@end
