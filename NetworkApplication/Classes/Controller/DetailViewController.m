//
//  DetailViewController.m
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-5.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "DetailViewController.h"
#import "HomeViewController.h"
#import "ProcessPhotoViewController.h"
#import "PeopleInformationViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"活动资料"];
    [self setSwipEnable:YES];
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 46, 44)];
    [leftBtn setImage:[UIImage imageNamed:@"toolbar_icon_menu.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(presentGridViewControllerWithTimeInterVal) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    [leftBtn release];
    [leftBarButtonItem release];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [TABBAR_VIEW_CONTROLLER setTabBarHidden:NO];
    
    if ([LocalData data].USER_LOGIN_STATUS_CHANGED) {
        
        [__requester setCallback:^(NSDictionary *dic) {
            [SVProgressHUD dismiss];
            self.party = (Party *)[__parser partyWithData:dic];
            [_tableView reloadData];
            [[LocalData data] setUSER_LOGIN_STATUS_CHANGED:NO];
        }];
        [__requester partyDetail:self.party.partyId];
        
        [SVProgressHUD showWithStatus:@"Loading..."];
    }
}

- (void)handlePartyChanged {
    [super handlePartyChanged];
    
    [_tableView setContentOffset:CGPointMake(0, 0)];
    [_tableView setDelegate:self];
    [_tableView reloadData];
    
    if (self.party.partyJoined == YES && self.navigationItem.rightBarButtonItem != nil) {
        self.navigationItem.rightBarButtonItem = nil;
        
    } else if (self.party.partyJoined == NO && self.navigationItem.rightBarButtonItem == nil) {/*
        UIBarButtonItem *rithtBarItem = [[UIBarButtonItem alloc] initWithTitle:@"报名"
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(takePartIn:)];
        self.navigationItem.rightBarButtonItem = rithtBarItem;*/
        
        UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 46, 44)];
        [rightBtn setImage:[UIImage imageNamed:@"toolbar_icon_join.png"] forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(takePartIn:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        [rightBtn release];
        [rightBarButtonItem release];
    }
    /*
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    UITableViewCell *cell  = [_tableView cellForRowAtIndexPath:indexPath];
    if (__cell_moved) {
        for (UIView *view in cell.subviews) {
            if (view.tag >= 1000) {
                view.frame = CGRectMake(view.frame.origin.x+(__cell_moved ? 320 : -320), view.frame.origin.y, view.frame.size.width, view.frame.size.height);
            }
        }
        __cell_moved = NO;
    }*/
}

- (void)takePartIn:(id)sender {
    
    if ([LocalData data].currentPeople == nil) {
        [self presentLoginViewController];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"报名参加该活动后将不能取消，您确定要参加吗？"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:@"取消", nil];
        [alert show];
        [alert release];
    }
}

#pragma mark - UIAlert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) return;
    
    [__requester setCallback:^(NSDictionary *dic) {
        
        int success = [[dic objectForKey:@"success"] intValue];
        
        switch (success) {
                
            case 0:
            {
                [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"msg"]];
            }
                break;
                
            case 1:
            {
                [SVProgressHUD showSuccessWithStatus:@"报名成功"];
                
                self.navigationItem.rightBarButtonItem = nil;
                [_tableView reloadData];
            }
                break;
                
            default:
                break;
        }
        
    }];
    [__requester joinParty:self.party.partyId];
    
    [SVProgressHUD showWithStatus:@"Loading..."];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    switch (indexPath.section) {
            
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_0"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell_0"];
            }
            
            UITextView *text = (UITextView *)[cell viewWithTag:1000];
            if (!text) {
                text = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
                text.font = [UIFont systemFontOfSize:16.0];
                text.backgroundColor = [UIColor clearColor];
                text.scrollEnabled = NO;
                text.userInteractionEnabled = NO;
                text.tag = 1000;
                [cell addSubview:text];
                [text release];
            }
            text.text = self.party.partyName;
            UIFont *font = [UIFont systemFontOfSize:16.0];
            CGSize size = [text.text sizeWithFont:font
                                constrainedToSize:CGSizeMake(320.0f, 1000.0f)
                                    lineBreakMode:UILineBreakModeWordWrap];
            text.frame = CGRectMake(0, 0, 320, size.height + 10);
        }
            break;
            
        case 1:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_1"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell_1"];
            }
            
            float width = (cell.bounds.size.width - 40)/3;
            GridViewItem *image = (GridViewItem *)[cell viewWithTag:1010];
            if (!image) {
                image = [[GridViewItem alloc] initWithFrame:CGRectMake(10, 10, width, width)];
                image.tag = 1010;
                [cell addSubview:image];
                [image release];
            }
            [image.imageView setImageWithURL:[NSURL URLWithString:IMAGE(self.party.partyIconId)]];
            
            UILabel *date = (UILabel *)[cell viewWithTag:1011];
            if (!date) {
                date = [[UILabel alloc] initWithFrame:CGRectMake(139, 12, 190, 15)];
                date.backgroundColor = [UIColor clearColor];
                date.font = [UIFont systemFontOfSize:16.0];
                date.tag = 1011;
                [cell addSubview:date];
                [date release];
            }
            date.text = [NSString stringWithFormat:@"%@  %@",
                         [Tools dateWithDate:self.party.partyDate],
                         [Tools timeWithDate:self.party.partyDate]];
            
            UITextView *address = (UITextView *)[cell viewWithTag:1012];
            if (!address) {
                address = [[UITextView alloc] initWithFrame:CGRectMake(130, 30, 200, 70)];
                address.backgroundColor = [UIColor clearColor];
                address.font = [UIFont systemFontOfSize:16.0];
                address.tag = 1012;
                address.scrollEnabled = NO;
                address.userInteractionEnabled = NO;
                [cell addSubview:address];
                [address release];
            }
            address.text = self.party.partyPlace;
            
            UIImageView *timeIcon = (UIImageView *)[cell viewWithTag:1013];
            if (!timeIcon) {
                timeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(120, 10, 16, 16)];
                timeIcon.tag = 1013;
                [cell addSubview:timeIcon];
                [timeIcon release];
            }
            timeIcon.image = [UIImage imageNamed:@"time.png"];
            
            UIImageView *lbsIcon = (UIImageView *)[cell viewWithTag:1014];
            if (!lbsIcon) {
                lbsIcon = [[UIImageView alloc] initWithFrame:CGRectMake(120, 40, 16, 16)];
                lbsIcon.tag = 1014;
                [cell addSubview:lbsIcon];
                [lbsIcon release];
            }
            lbsIcon.image = [UIImage imageNamed:@"lbs.png"];
        }
            break;
            
        case 2:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_2"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell_2"];
            }
            
            float width = (cell.bounds.size.width - 40)/3;
            GridViewItem *icon = (GridViewItem *)[cell viewWithTag:1020];
            if (!icon) {
                icon = [[GridViewItem alloc] initWithFrame:CGRectMake(10, 10, width, width)];
                icon.tag = 1020;
                icon.delegate = self;
                [cell addSubview:icon];
                [icon release];
            }
            [icon.imageView setImageWithURL:IMAGE(self.party.sponsor.peopleHeaderURL)];
            
            UILabel *label1 = (UILabel *)[cell viewWithTag:1021];
            if (!label1) {
                label1 = [[UILabel alloc] initWithFrame:CGRectMake(139, 12, 190, 15)];
                label1.backgroundColor = [UIColor clearColor];
                label1.font = [UIFont systemFontOfSize:16.0];
                label1.tag = 1021;
                [cell addSubview:label1];
                [label1 release];
            }
            label1.text = [NSString stringWithFormat:@"举办人  %@", self.party.sponsor.peopleNickName];
            
            UITextView *label2 = (UITextView *)[cell viewWithTag:1022];
            if (!label2) {
                label2 = [[UITextView alloc] initWithFrame:CGRectMake(130, 30, 190, 70)];
                label2.backgroundColor = [UIColor clearColor];
                label2.font = [UIFont systemFontOfSize:16.0];
                label2.tag = 1022;
                label2.scrollEnabled = NO;
                label2.userInteractionEnabled = NO;
                [cell addSubview:label2];
                [label2 release];
            }
            label2.text = self.party.partyJoined ? @"此活动  我已参加" : @"此活动  我尚未参加";
            
            UIImageView *peopleIcon = (UIImageView *)[cell viewWithTag:1023];
            if (!peopleIcon) {
                peopleIcon = [[UIImageView alloc] initWithFrame:CGRectMake(120, 10, 16, 16)];
                peopleIcon.tag = 1023;
                [cell addSubview:peopleIcon];
                [peopleIcon release];
            }
            peopleIcon.image = [UIImage imageNamed:@"sponsor.png"];
            
            UIImageView *meetingIcon = (UIImageView *)[cell viewWithTag:1024];
            if (!meetingIcon) {
                meetingIcon = [[UIImageView alloc] initWithFrame:CGRectMake(120, 40, 16, 16)];
                meetingIcon.tag = 1024;
                [cell addSubview:meetingIcon];
                [meetingIcon release];
            }
            meetingIcon.image = [UIImage imageNamed:@"meeting.png"];
            /*
            UIButton *swi = (UIButton *)[cell viewWithTag:1030];
            if (!swi) {
                swi = [UIButton buttonWithType:UIButtonTypeCustom];
                swi.layer.borderColor = RGBA(0, 0, 0, .25).CGColor;
                swi.layer.borderWidth = 1;
                
                swi.frame = CGRectMake(330, 10, 300, 30);
                [swi setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [swi setBackgroundImage:[UIImage imageNamed:@"listbg.png"] forState:UIControlStateNormal];
                //[swi setBackgroundImage:[UIImage imageNamed:@"listbg.png"] forState:UIControlStateHighlighted];
                [swi addTarget:self action:@selector(takePartIn:) forControlEvents:UIControlEventTouchUpInside];
                swi.tag = 1030;
                [cell addSubview:swi];
            }
            if (self.party.partyJoined) {
                [swi setTitle:@"已参加" forState:UIControlStateNormal];
            } else {
                [swi setTitle:@"参  加" forState:UIControlStateNormal];
            }*/
        }
            break;
        
        case 3:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_4"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell_4"];
            }
            
            UITextView *text = (UITextView *)[cell viewWithTag:1040];
            if (!text) {
                text = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
                text.font = [UIFont systemFontOfSize:16.0];
                text.backgroundColor = [UIColor clearColor];
                text.scrollEnabled = NO;
                text.userInteractionEnabled = NO;
                text.tag = 1040;
                [cell addSubview:text];
                [text release];
            }
            text.text = self.party.partyIntroduce;
            UIFont *font = [UIFont systemFontOfSize:16.0];
            CGSize size = [text.text sizeWithFont:font
                                constrainedToSize:CGSizeMake(320.0f, 1000.0f)
                                    lineBreakMode:UILineBreakModeWordWrap];
            text.frame = CGRectMake(0, 0, 320, size.height + 10);
        }
            break;
            
        case 4:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_3"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell_3"];
            }
            
            float width = (cell.bounds.size.width - 40)/3;
            for (int i = 0; i < [self.party.partyPrevious count]; i++) {
                
                GridViewItem *item = (GridViewItem *)[cell viewWithTag:1030 + i];
                if (!item) {
                    item = [[GridViewItem alloc] initWithFrame:CGRectMake((width + 10) * i + 10, 10, width, width)];
                    item.tag = 1030 + i;
                    [item setIndex:i];
                    [item setDelegate:self];
                    [cell addSubview:item];
                    [item release];
                }
                Image *image = (Image *)[self.party.partyPrevious objectAtIndex:i];
                [item.imageView setImageWithURL:[NSURL URLWithString:IMAGE(image.imageId)]];
            }
        }
            break;
            
        default:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            }
        }
            break;
    }
    
    //cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"listbg.png"]] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
            
        case 0: return 60;
            break;
        case 3:
        {
            UIFont *font = [UIFont systemFontOfSize:16.0];
            CGSize size = [self.party.partyIntroduce sizeWithFont:font
                                                constrainedToSize:CGSizeMake(320.0f, 1000.0f)
                                                    lineBreakMode:UILineBreakModeWordWrap];
            return size.height + 20;
        }
            break;
        case 1: 
        case 2: 
        case 4: return (tableView.frame.size.width - 40)/3 + 20;
            break;
        default:
            break;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)] autorelease];
    label.backgroundColor = [UIColor whiteColor];//RGB(238, 238, 238);
    label.textColor = [UIColor darkTextColor];
    label.font = [UIFont boldSystemFontOfSize:16.0];
    
    switch (section) {
            
        case 0: label.text = @"  活动说明";
            break;
        case 1: label.text = @"  时间地点";
            break;
        case 2: label.text = @"  主办信息";
            break;
        case 3: label.text = @"  活动介绍";
            break;
        case 4: label.text = @"  活动预告";
            break;
        default:
            break;
    }
    
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    if (indexPath.section == 2) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        [UIView animateWithDuration:.25 animations:^{
            
            for (UIView *view in cell.subviews) {
                
                if (view.tag >= 1000) {
                    view.frame = CGRectMake(view.frame.origin.x+(__cell_moved ? 320 : -320), view.frame.origin.y, view.frame.size.width, view.frame.size.height);
                }
            }
            
        }];
        
        __cell_moved = !__cell_moved;
    }*/
}

#pragma mark - GridViewItemDelegate

- (void)gridViewItem:(GridViewItem *)gridViewItem didSelectedItemAtIndex:(NSInteger)index {
    
    if (gridViewItem.tag == 1010) {
        // 点击Party大图
        
    } else if (gridViewItem.tag == 1020) {
        // 点击Party举办人
        PeopleInformationViewController *controller =
        [[PeopleInformationViewController alloc] initWithNibName:@"PeopleInformationViewController" bundle:nil];
        controller.people = self.party.sponsor;
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
        
    } else if (gridViewItem.tag >= 1030) {
        ProcessPhotoViewController *viewController = [[ProcessPhotoViewController alloc] init];
        viewController.photos = self.party.partyPrevious;
        viewController.pageIndex = gridViewItem.tag - 1030;
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end
