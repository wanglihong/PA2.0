//
//  MemberViewController.m
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-10.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "MemberViewController.h"
#import "PeopleInformationViewController.h"
#import "PeopleInfoView.h"

@interface MemberViewController ()

@end

@implementation MemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"PA友"];
    [self setSwipEnable:YES];
    
    _gmGridView.style = GMGridViewStyleSwap;
    _gmGridView.itemSpacing = 4;
    _gmGridView.minEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
    _gmGridView.clipsToBounds = YES;
    _gmGridView.centerGrid = NO;
    _gmGridView.mainSuperView = self.navigationController.view;
    
    _data = [[NSMutableArray alloc] init];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [TABBAR_VIEW_CONTROLLER setTabBarHidden:NO];
    
    if ( [LocalData data].USER_INFORMATION_CHANGED ) {
        [self handlePartyChanged];
        [[LocalData data] setUSER_INFORMATION_CHANGED:NO];
    }
}

- (void)handlePartyChanged {
    [super handlePartyChanged];
    
    [_gmGridView setContentOffset:CGPointMake(0, 0)];
    
    [__requester setCallback:^(NSDictionary *dic) {
        [_data removeAllObjects];
        [_data addObjectsFromArray:[__parser peoplesWithData:dic]];
        _total = [__parser listLengthWithData:dic];
        [_gmGridView reloadData];
        [SVProgressHUD dismiss];
    }];
    [__requester memberListOfParty:self.party.partyId fromPosition:0 withLength:30];
    
    [SVProgressHUD showWithStatus:@"Loading..."];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if ( [self needLoadMore] == YES ) {
        [__requester setCallback:^(NSDictionary *dic) {
            [_data addObjectsFromArray:[__parser peoplesWithData:dic]];
            [_gmGridView reloadData];
            [SVProgressHUD dismiss];
        }];
        [__requester memberListOfParty:self.party.partyId fromPosition:[_data count] withLength:30];
        
        [SVProgressHUD showWithStatus:@"Loading..."];
    }
}

- (BOOL)needLoadMore {
    BOOL isBottom = (_gmGridView.contentOffset.y + _gmGridView.frame.size.height) == _gmGridView.contentSize.height ? YES : NO;
    BOOL isLast = [_data count] < _total ? NO : YES ;
    return (isBottom & !isLast);
}

#pragma mark GMGridViewDataSource

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView {
    return [_data count];
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation {
    return CGSizeMake( (gridView.frame.size.width - 16) / 3, (gridView.frame.size.width - 16) / 3);
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index {
    CGSize size = [self GMGridView:gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    
    if (!cell) {
        cell = [[[GMGridViewCell alloc] init] autorelease];
        cell.deleteButtonIcon = [UIImage imageNamed:@"close_x.png"];
        cell.deleteButtonOffset = CGPointMake(-15, -15);
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        view.backgroundColor = [UIColor blackColor];
        view.layer.masksToBounds = NO;
        
        cell.contentView = view;
        [view release];
    }
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    People *p = [_data objectAtIndex:index];
    
    UIImageView *item = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [item setImageWithURL:[NSURL URLWithString:IMAGE(p.peopleHeaderURL)]
         placeholderImage:[UIImage imageNamed: [p.peopleGender isEqual:@"f"] ? @"default_woman.png" : @"default_man.png"]];
    [cell.contentView addSubview:item];
    [item release];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, size.height - 20, size.width, 20)];
    nameLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
    nameLabel.font = [UIFont systemFontOfSize:12.0];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.text = p.peopleNickName;
    [cell.contentView addSubview:nameLabel];
    [nameLabel release];
    
    UIImageView *sex = [[UIImageView alloc] initWithFrame:CGRectMake(size.width - 20, size.height - 20, 20, 20)];
    sex.image = [UIImage imageNamed: [p.peopleGender isEqual:@"f"] ? @"female.png" : @"male.png"];
    [cell.contentView addSubview:sex];
    [sex release];
    
    return cell;
}


- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index {
    return YES; //index % 2 == 0;
}

#pragma mark GMGridViewActionDelegate

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position {
    
    //GMGridViewCell *cell = [gridView cellForItemAtIndex:position];
    People *p = [_data objectAtIndex:position];
    
    // cell 所在 gridView坐标系的坐标 转换成 屏幕坐标系坐标
    //CGRect rect = CGRectMake(cell.frame.origin.x, cell.frame.origin.y - gridView.contentOffset.y + 64, cell.frame.size.width, cell.frame.size.height);
    //[[PeopleInfoView sharedView] showPeopleInfo:p atPosition:rect];
    
    PeopleInformationViewController *controller =
    [[PeopleInformationViewController alloc] initWithNibName:@"PeopleInformationViewController" bundle:nil];
    controller.people = p;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)GMGridViewDidTapOnEmptySpace:(GMGridView *)gridView {
    NSLog(@"Tap on empty space");
}

- (void)GMGridView:(GMGridView *)gridView processDeleteActionForItemAtIndex:(NSInteger)index {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you want to delete this item?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    
    [alert show];
    [alert release];
    
    _lastDeleteItemIndexAsked = index;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [_data removeObjectAtIndex:_lastDeleteItemIndexAsked];
        [_gmGridView removeObjectAtIndex:_lastDeleteItemIndexAsked withAnimation:GMGridViewItemAnimationFade];
    }
}

#pragma mark GMGridViewSortingDelegate

- (void)GMGridView:(GMGridView *)gridView didStartMovingCell:(GMGridViewCell *)cell {
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor orangeColor];
                         cell.contentView.layer.shadowOpacity = 0.7;
                     }
                     completion:nil
     ];
}

- (void)GMGridView:(GMGridView *)gridView didEndMovingCell:(GMGridViewCell *)cell {
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         cell.contentView.backgroundColor = [UIColor redColor];
                         cell.contentView.layer.shadowOpacity = 0;
                     }
                     completion:nil
     ];
}

- (BOOL)GMGridView:(GMGridView *)gridView shouldAllowShakingBehaviorWhenMovingCell:(GMGridViewCell *)cell atIndex:(NSInteger)index {
    return YES;
}

- (void)GMGridView:(GMGridView *)gridView moveItemAtIndex:(NSInteger)oldIndex toIndex:(NSInteger)newIndex {
    NSObject *object = [_data objectAtIndex:oldIndex];
    [_data removeObject:object];
    [_data insertObject:object atIndex:newIndex];
}

- (void)GMGridView:(GMGridView *)gridView exchangeItemAtIndex:(NSInteger)index1 withItemAtIndex:(NSInteger)index2 {
    [_data exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
}

- (void)dealloc {
    [_data release];
    [super dealloc];
}

@end
