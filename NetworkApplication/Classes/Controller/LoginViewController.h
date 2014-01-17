//
//  LoginViewController.h
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-13.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "NetworkViewController.h"

@interface LoginViewController : NetworkViewController <UITextFieldDelegate> {
    IBOutlet UITableView *_tableView;
}

@end
