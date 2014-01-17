//
//  DetailViewController.h
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-5.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "PartyViewController.h"
#import "GridViewItem.h"

@interface DetailViewController : PartyViewController <UITableViewDataSource, UITableViewDelegate, GridViewItemDelegate> {
    IBOutlet UITableView *_tableView;
    BOOL __cell_moved;
}

@end
