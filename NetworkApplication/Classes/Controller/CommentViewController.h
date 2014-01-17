//
//  CommentViewController.h
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-21.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "PartyViewController.h"
#import "BottomInputBar.h"
#import "Image.h"

@interface CommentViewController : PartyViewController <BottomInputBarDelegate> {
    Image *_photo;
    NSMutableArray *_data;
    NSInteger _total;
    
    IBOutlet UITableView *_tableView;
    IBOutlet BottomInputBar *_bottombar;
}

@property (nonatomic, retain) Image *photo;

@end
