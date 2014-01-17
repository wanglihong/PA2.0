//
//  PeopleInformationViewController.h
//  NetworkApplication
//
//  Created by Dennis Yang on 13-2-4.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import "PartyViewController.h"

@interface PeopleInformationViewController : PartyViewController {
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIImageView *bigImage;
    IBOutlet UIImageView *smaImage;
    IBOutlet UILabel *nickNameLabel;
    IBOutlet UILabel *realNameLabel;
    IBOutlet UILabel *deptmentLabel;
    IBOutlet UILabel *qqNumberLabel;
    IBOutlet UILabel *emailLabel;
    IBOutlet UITextView *decrptView;
}

@property (nonatomic, retain) People *people;

@end
