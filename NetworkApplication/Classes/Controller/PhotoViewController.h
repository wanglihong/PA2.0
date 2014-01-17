//
//  PhotoViewController.h
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-10.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "PartyViewController.h"
#import "WaterflowView.h"

@interface PhotoViewController : PartyViewController <WaterflowViewDelegate,WaterflowViewDatasource,UIScrollViewDelegate> {
    WaterflowView *_flowView;
    
    NSMutableArray *_data;
    NSInteger _total;
}


@end
