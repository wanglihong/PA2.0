//
//  PhotoViewController.m
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-10.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "PhotoViewController.h"
#import "ProcessPhotoViewController.h"
#import "TabBarViewController.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"PA图秀"];
    [self setSwipEnable:YES];
    
    _flowView = [[WaterflowView alloc] initWithFrame:CGRectMake(2, 2, self.view.frame.size.width - 4, self.view.frame.size.height)];
    _flowView.autoresizingMask = self.view.autoresizingMask;
    [self.view addSubview:_flowView];
    [_flowView release];
    
    _data = [[NSMutableArray alloc] init];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [TABBAR_VIEW_CONTROLLER setTabBarHidden:NO];
    
    if ([LocalData data].HAVE_NEW_PHOTO) {
        [self handlePartyChanged];
        [LocalData data].HAVE_NEW_PHOTO = NO;
    }
}

- (void)handlePartyChanged {
    [super handlePartyChanged];
    
    [_flowView setContentOffset:CGPointMake(0, 0)];
    
    [__requester setCallback:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        [_data removeAllObjects];
        [_data addObjectsFromArray:[__parser photosWithData:dic]];
        
        _total = [__parser listLengthWithData:dic];
        NSLog(@"------------------------>%d, %d", _data.count, _total);
        if (_total == 0) {
            return;
        }
        
        if (_flowView.flowdelegate == nil && _flowView.flowdatasource == nil) {
            _flowView.flowdatasource = self;
            _flowView.flowdelegate = self;
        }
        [_flowView reloadData];
    }];
    [__requester photoListOfParty:self.party.partyId fromPosition:0 withLength:20];
    
    [SVProgressHUD showWithStatus:@"Loading..."];
}

#pragma mark - UIScrollViewDelegate
/*
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if ( [self needLoadMore] == YES ) {
        [__requester setCallback:^(NSDictionary *dic) {
            [_data addObjectsFromArray:[__parser photosWithData:dic]];
            [_flowView reloadData];
            [SVProgressHUD dismiss];
        }];
        [__requester photoListOfParty:self.party.partyId fromPosition:[_data count] withLength:20];
        
        [SVProgressHUD showWithStatus:@"Loading..."];
    }
}
*/
- (BOOL)needLoadMore {
    //float bottomEdge = _flowView.contentOffset.y + _flowView.frame.size.height;
    //BOOL isBottom = ( bottomEdge == _flowView.contentSize.height ? YES : NO );
    BOOL isLast = [_data count] < _total ? NO : YES ;
    
    return !isLast;//(isBottom & !isLast);
}

#pragma mark-
#pragma mark- WaterflowDataSource

- (NSInteger)numberOfColumnsInFlowView:(WaterflowView *)flowView {
    return 3;
}

- (NSInteger)flowView:(WaterflowView *)flowView numberOfRowsInColumn:(NSInteger)column {
    return ceil( [_data count]/3.0 );
}

- (WaterFlowCell*)flowView:(WaterflowView *)flowView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
	WaterFlowCell *cell = [flowView_ dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if(cell == nil) {
		cell  = [[[WaterFlowCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
        
        UIImageView *item = [[UIImageView alloc] initWithFrame:CGRectZero];
        item.contentMode = UIViewContentModeScaleToFill;
        item.contentMode = UIViewContentModeScaleAspectFill;
        item.clipsToBounds = YES;
		item.layer.borderColor = [[UIColor whiteColor] CGColor];
		item.layer.borderWidth = 2;
        item.tag = 1000;
        [cell addSubview:item];
        [item release];
        
        UILabel *lbe = [[UILabel alloc] initWithFrame:CGRectZero];
        lbe.backgroundColor = [UIColor colorWithWhite:0 alpha:.75];
        lbe.font = [UIFont systemFontOfSize:12.0];
        lbe.textColor = [UIColor whiteColor];
        lbe.tag = 1001;
        [cell addSubview:lbe];
        [lbe release];
        
        UIImageView *good = [[UIImageView alloc] initWithFrame:CGRectZero];
        good.image = [UIImage imageNamed:@"support.png"];
        good.tag = 1002;
        [cell addSubview:good];
        [good release];
        
        UILabel *num = [[UILabel alloc] initWithFrame:CGRectZero];
        num.backgroundColor = [UIColor clearColor];
        num.font = [UIFont systemFontOfSize:14.0];
        num.textColor = [UIColor whiteColor];
        num.tag = 1003;
        [cell addSubview:num];
        [num release];
	}
	
	float height = [self flowView:flowView_ heightForRowAtIndexPath:indexPath];
    NSInteger trueIndex = (indexPath.row * 3 + indexPath.section);
    
    if (trueIndex < [_data count]) {
        Image *img = [_data objectAtIndex:trueIndex];
        
        UIImageView *item = (UIImageView *)[cell viewWithTag:1000];
        item.frame = CGRectMake(0, 0, flowView_.frame.size.width/3, height);
        [item setImageWithURL:[NSURL URLWithString:IMAGE(img.image_180)]];
        
        UILabel *lbe = (UILabel *)[cell viewWithTag:1001];
        lbe.frame = CGRectMake(2, item.frame.size.height - 22, item.frame.size.width - 4, 20);
        lbe.text = img.people.peopleNickName;
        
        UIImageView *good = (UIImageView *)[cell viewWithTag:1002];
        good.frame = CGRectMake(item.frame.size.width - 37, item.frame.size.height - 19, 15, 15);
        
        UILabel *num = (UILabel *)[cell viewWithTag:1003];
        num.frame = CGRectMake(item.frame.size.width - 22, item.frame.size.height - 22, 20, 20);
        num.text = [NSString stringWithFormat:@"%d", img.supportCount];
    }
    
	return cell;
}

#pragma mark-
#pragma mark- WaterflowDelegate

- (CGFloat)flowView:(WaterflowView *)flowView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger trueIndex = indexPath.row * 3 + indexPath.section;
    //float height[10] = {110, 80, 70, 110, 100, 60, 140, 200, 190, 170};
    float height[10] = {180, 100, 140, 120, 220, 160, 110, 170, 130, 150};
    //float height[10] = {147, 101, 123, 101, 180, 135, 117, 101, 156, 169};
    
	return height[trueIndex % 10] + indexPath.row + indexPath.section;
}

- (void)flowView:(WaterflowView *)flowView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger trueIndex = indexPath.row * 3 + indexPath.section;
    
    ProcessPhotoViewController *viewController = [[ProcessPhotoViewController alloc] init];
    viewController.photos = _data;
    viewController.pageIndex = trueIndex;
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)flowViewReachesBottom {
    
    if ( [self needLoadMore] == YES ) {
        [__requester setCallback:^(NSDictionary *dic) {
            [_data addObjectsFromArray:[__parser photosWithData:dic]];
            [_flowView reloadData];
            [SVProgressHUD dismiss];
        }];
        [__requester photoListOfParty:self.party.partyId fromPosition:[_data count] withLength:20];
        
        [SVProgressHUD showWithStatus:@"Loading..."];
    }
}

- (void)dealloc {
    [_data release];
    [super dealloc];
}

@end
