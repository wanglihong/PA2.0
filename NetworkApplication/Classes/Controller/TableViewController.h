//
//  TableViewController.h
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-18.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "NetworkViewController.h"
#import "GMGridView.h"
#import "Party.h"

@interface TableViewController : UITableViewController <UITextFieldDelegate, UITextViewDelegate> {
    IBOutlet UITableView *_tableView;
}

- (UITextField *)fieldForRow:(NSInteger)row inSection:(NSInteger)section;
- (UITextView *)textViewForRow:(NSInteger)row inSection:(NSInteger)section;

@end
