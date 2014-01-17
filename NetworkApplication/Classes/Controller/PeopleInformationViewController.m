//
//  PeopleInformationViewController.m
//  NetworkApplication
//
//  Created by Dennis Yang on 13-2-4.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import "PeopleInformationViewController.h"

@interface PeopleInformationViewController ()

@end

@implementation PeopleInformationViewController

@synthesize people;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"个人信息";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height + 45);
    smaImage.layer.cornerRadius = 4;
    smaImage.layer.borderWidth = 2;
    smaImage.layer.borderColor = [UIColor whiteColor].CGColor;
    smaImage.layer.masksToBounds = YES;
    
    if (people.peopleHeaderURL) {
        [bigImage setImageWithURL:[NSURL URLWithString:IMAGE(people.peopleHeaderURL)]];
        [smaImage setImageWithURL:[NSURL URLWithString:IMAGE(people.peopleHeaderURL)]];
    } else {
        [bigImage setImage:LOCAL_IMAGE(@"Background", @"jpg")];
        [smaImage setImage:LOCAL_IMAGE(@"Background", @"jpg")];
    }
    
    [nickNameLabel setText:people.peopleNickName];
    [realNameLabel setText:COMBINE(@"真名  ", people.peopleRealName)];
    [deptmentLabel setText:people.peopleDepartment];
    [qqNumberLabel setText:COMBINE(@"QQ  ", people.peopleQQ)];
    [emailLabel    setText:COMBINE(@"Email  ", people.peopleEmail)];
    [decrptView    setText:people.peopleInformation];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [TABBAR_VIEW_CONTROLLER setTabBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [people release];
    [super dealloc];
}

@end
