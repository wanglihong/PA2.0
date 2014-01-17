//
//  HomeViewController.m
//  NetworkApplication
//
//  Created by Dennis Yang on 12-10-29.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "HomeViewController.h"
#import "GridViewItem.h"

#define TITLE_AREA_HEIGHT 25

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize parties = _parties;

- (id)init {
    
    if (self == [super init]) {
        
        //self.view.clipsToBounds = YES;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.clipsToBounds = YES;
        _scrollView.backgroundColor = [UIColor clearColor];
        
        _background = [[UIImageView alloc] initWithFrame:CGRectMake(-320/10, 0, 320*2.5, _scrollView.frame.size.height)];
        _background.contentMode = UIViewContentModeScaleAspectFill;
        _background.image = LOCAL_IMAGE(@"Background", @"jpg");
        //_background.frame = CGRectMake(-_scrollView.frame.size.width/10, 0, _background.frame.size.width, _background.frame.size.height);
        
        UIView *_contentView = [[UIView alloc] initWithFrame:self.view.bounds];
        _contentView.clipsToBounds = YES;
        [_contentView addSubview:_background];
        [_background release];

        [self.view addSubview:_contentView];
        [_contentView release];
        [self.view addSubview:_scrollView];
        [_scrollView release];
        /*
        UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
        gestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
        [self.view addGestureRecognizer:gestureRecognizer];
        [gestureRecognizer release];
         */
        
        
        /*
        UIImage *shadow = [UIImage imageNamed:@"view_shadow_right.png"];
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (version >= 5.0)
            [shadow resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        else
            [shadow stretchableImageWithLeftCapWidth:0 topCapHeight:2];
        */
        UIImageView *_view_shadow_right = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width, 0, 17, self.view.bounds.size.height)];
        [_view_shadow_right setImage:[UIImage imageNamed:@"view_shadow_right.png"]];
        [self.view addSubview:_view_shadow_right];
        [_view_shadow_right release];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestPartyList];
}

- (void)requestPartyList {
    
    [_requester setCallback:^(NSDictionary *dic) {
        self.parties = [_parser partiesWithData:dic];
        [self update];
    }];
    [_requester partyListFromPosition:0 withLength:100];
}

- (void)update {
    
    int onePageCount = 8;
    int pages = ceil([_parties count] / (float)onePageCount);
    
    for (int i = 0; i < [_parties count]; i++) {
        
        float width = __IPHONE5 ? 114 : 100;
        float gap = __IPHONE5 ? 8 : 12;
        float leftMargin = __IPHONE5 ? 16 : 30;
        float topMargin = __IPHONE5 ? 35 : 15;
        float x = (width + gap) * (i%2) + leftMargin + floor(i/onePageCount) * _scrollView.bounds.size.width;
        float y = (width + gap) * ((i%onePageCount)/2) + topMargin;
        
        Party *party = [_parties objectAtIndex:i];
        GridViewItem *item = [[GridViewItem alloc] initWithFrame:CGRectMake(x, y, width, width)];
        
        [item.imageView setImageWithURL:[NSURL URLWithString:IMAGE(party.partyIconId)]];
        //[item.imageView setAlpha:.9];
        [item.shadow setImage:[UIImage imageNamed:@"ZKAD_borderShadow.png"]];
        [item setDelegate:self];
        [item setIndex:i];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, item.frame.size.height - TITLE_AREA_HEIGHT, item.frame.size.width, TITLE_AREA_HEIGHT)];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor colorWithWhite:.0 alpha:0.5];
        titleLabel.font = [UIFont systemFontOfSize:12.0];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = party.partyTitle;
        [item addSubview:titleLabel];
        [titleLabel release];
        
        if (party.partyJoined) {
            UIImageView *sure = [[UIImageView alloc] initWithFrame:CGRectMake(width*2/3, 0, width/3, width/3)];
            sure.image = [UIImage imageNamed:@"sure_n.png"];
            [item addSubview:sure];
            [sure release];
        }
        
        [_scrollView addSubview:item];
        [item release];
    }
    
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width * pages, _scrollView.bounds.size.height);
}

- (void)gridViewItem:(GridViewItem *)gridViewItem didSelectedItemAtIndex:(NSInteger)index {
    
    [_requester setCallback:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        [self updatePartyInformation:(Party *)[_parser partyWithData:dic]];
    }];
    [_requester partyDetail:((Party *)[_parties objectAtIndex:index]).partyId];
    
    [SVProgressHUD showWithStatus:@"Loading..."];
}

- (void)updatePartyInformation:(Party *)party {
    [[LocalData data] setCurrentParty:party];
    [self moveOutFromScreen];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PartyChanged" object:party];
}

- (void)moveOutFromScreen {
    [UIView animateWithDuration:.35
                     animations:^{
                         [self.view setFrame:CGRectMake(-self.view.frame.size.width, 0,
                                                        self.view.frame.size.width, self.view.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                         [self.view removeFromSuperview];
                     }];
}

- (void)swipe:(UISwipeGestureRecognizer *)recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        [self moveOutFromScreen];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    float x = scrollView.contentOffset.x;
    _background.frame = CGRectMake(-_scrollView.frame.size.width/10 - x/10, 0, _background.frame.size.width, _background.frame.size.height);
}

- (void)dealloc
{
    [_parties release];
    [super dealloc];
}

@end
