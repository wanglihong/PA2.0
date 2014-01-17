//
//  ProcessPhotoViewController.m
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-18.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "ProcessPhotoViewController.h"
#import "CommentViewController.h"
#import "TabBarViewController.h"
#import "Image.h"
#import "AudioPlayer.h"

@interface ProcessPhotoViewController ()

@end

@implementation ProcessPhotoViewController

@synthesize photos = _photos;
@synthesize pages = _pages;
@synthesize pageIndex = _pageIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.title = @"PA图秀";
    _titleView = [[PhotoTitleView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
    self.navigationItem.titleView = _titleView;
    [_titleView release];
    /*
    UIBarButtonItem *rithtBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                                  target:self
                                                                                  action:@selector(compose)];
    self.navigationItem.rightBarButtonItem = rithtBarItem;
    */
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_scrollView];
    [_scrollView release];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    recognizer.cancelsTouchesInView = NO;
    [_scrollView addGestureRecognizer:recognizer];
    [recognizer release];
    
    UIView *toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 44)];
    toolBar.backgroundColor = [UIColor colorWithWhite:1 alpha:.15];
    toolBar.tag = 1000;
    toolBar.hidden = YES;
    [self.view addSubview:toolBar];
    [toolBar release];
    
    UIButton *voteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [voteBtn setImage:[UIImage imageNamed:@"feeddetail_like_btn.png"] forState:UIControlStateNormal];
    voteBtn.frame = CGRectMake(0, 0, 60, 44);
    [voteBtn addTarget:self action:@selector(vote) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:voteBtn];
    
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playBtn setImage:[UIImage imageNamed:@"photo_play_btn.png"] forState:UIControlStateNormal];
    playBtn.frame = CGRectMake(85, 0, 60, 44);
    playBtn.tag = 1002;
    [playBtn addTarget:self action:@selector(playVoice:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:playBtn];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"actions.png"] forState:UIControlStateNormal];
    shareBtn.frame = CGRectMake(170, 0, 60, 44);
    [shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:shareBtn];
    
    UIButton *commBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [commBtn setImage:[UIImage imageNamed:@"feeds_comment_btn.png"] forState:UIControlStateNormal];
    commBtn.frame = CGRectMake(260, 0, 60, 44);
    [commBtn addTarget:self action:@selector(compose) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:commBtn];
    
    [self setUpScrollViewContent];
    [self setupScrollViewContentSize];
    [self moveToPageAtIndex:_pageIndex animated:NO];
    [self performSelector:@selector(showToolBar:) withObject:toolBar afterDelay:.5];
}

- (void)showToolBar:(UIView *)toolbar {
    [toolbar setHidden:NO];
}

- (void)playVoice:(id)sender {
    Image *photo = [self.photos objectAtIndex:_pageIndex];
    if (photo.imageVoiceId) {
        NSData *amr = [NSData dataWithContentsOfURL:[NSURL URLWithString:IMAGE(photo.imageVoiceId)]];
        [[AudioPlayer player] play_amr:amr sender:sender];
    }
}

- (void)vote {
    if ([LocalData data].currentPeople == nil) {
        [self presentLoginViewController];
        
    } else {
        Image *photo = [self.photos objectAtIndex:_pageIndex];
        if (photo.hasSupported >= 1) {
            [SVProgressHUD showErrorWithStatus:@"您已经投过票啦！"];
            return;
        }
        
        [__requester setCallback:^(NSDictionary *dic) {
            [SVProgressHUD showSuccessWithStatus:@"成功为照片投了一票！"];
            photo.hasSupported += 1;
        }];
        [__requester addGood:photo.imageId];
        
        [SVProgressHUD showWithStatus:@"Loading..."];
    }
}

- (void)compose {
    CommentViewController *viewController = [[CommentViewController alloc] initWithNibName:@"CommentViewController" bundle:nil];
    viewController.photo = [self.photos objectAtIndex:_pageIndex];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:YES];
    [self setWantsFullScreenLayout:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self setWantsFullScreenLayout:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [TABBAR_VIEW_CONTROLLER setTabBarHidden:YES];
    [self setToolBarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)viewTapped:(UITapGestureRecognizer *)recognizer {
    [self setToolBarHidden:!self.navigationController.navigationBarHidden];
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:![UIApplication sharedApplication].statusBarHidden withAnimation:UIStatusBarAnimationFade];
}

- (void)setToolBarHidden:(BOOL)hidden {
    UIView *toolBar = [self.view viewWithTag:1000];
    
    [UIView animateWithDuration:.25 animations:^{
        toolBar.frame = CGRectMake(0, self.view.frame.size.height + (hidden ? 44 : -44), self.view.frame.size.width, 44);
    }];
}

- (void)updatePhotoInformation:(NSInteger)index {
    _share_image = ((UIImageView *)[self.pages objectAtIndex:index]).image;
    
    Image *currentPhoto = (Image *)[_photos objectAtIndex:index];
    _titleView.titleLabel.text = [currentPhoto people].peopleNickName;
    _titleView.descrLabel.text = [currentPhoto imageDate];
    
    UIView *toolbar = [self.view viewWithTag:1000];
    UIView *playbtn = [toolbar viewWithTag:1002];
    [playbtn setHidden:!currentPhoto.imageVoiceId];
}

- (void)setUpScrollViewContent
{
    NSMutableArray *pages = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < [self.photos count]; i++) {
        [pages addObject:[NSNull null]];
    }
    self.pages = pages;
    [pages release];
}

- (void)setupScrollViewContentSize
{
	CGSize contentSize = _scrollView.bounds.size;
	contentSize.width = _scrollView.bounds.size.width * [_pages count];
    contentSize.height = contentSize.height;
	
	if (!CGSizeEqualToSize(contentSize, _scrollView.contentSize)) {
		_scrollView.contentSize = contentSize;
	}
}

- (void)enqueuePageViewAtIndex:(int)theIndex
{
    for (int i = 0; i < [self.pages count]; i++)
    {
        UIImageView *view = [self.pages objectAtIndex:i];
        if((NSNull *)view != [NSNull null])
        {
            if(i < theIndex-1 || i > theIndex+1)
            {
                [view removeFromSuperview];
                [self.pages replaceObjectAtIndex:i withObject:[NSNull null]];
            }
        }
    }
}

- (int )centerPageIndex
{
    CGFloat pageWidth = _scrollView.frame.size.width;
	return floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}

- (void)loadScrollViewWithPage:(int)page
{
#define PAGE_GAP 20
    if (page < 0) return;
    if (page >= [self.pages count]) return;
    
    UIImageView *view = (UIImageView *)[self.pages objectAtIndex:page];
    
    if ((NSNull*)view == [NSNull null]) {
		
        Image *img = [self.photos objectAtIndex:page];
        
        view = [[UIImageView alloc] initWithFrame:[_scrollView frame]];
        view.contentMode = UIViewContentModeScaleAspectFit;
        view.clipsToBounds = YES;
        view.backgroundColor = [UIColor blackColor];
        view.autoresizingMask = _scrollView.autoresizingMask;
        [view setImageWithURL:[NSURL URLWithString:IMAGE(img.image_360 ? img.image_360 : img.imageId)]];
		[self.pages replaceObjectAtIndex:page withObject:view];
        [view release];
	}
	
    if (nil == view.superview) {
        [_scrollView addSubview:view];
    }
    
    CGRect frame = _scrollView.frame;
	NSInteger centerPageIndex = _pageIndex;
	CGFloat xOrigin = (frame.size.width * page);
	if (page > centerPageIndex) {
		xOrigin = (frame.size.width * page) + PAGE_GAP;
	} else if (page < centerPageIndex) {
		xOrigin = (frame.size.width * page) - PAGE_GAP;
	}
	
	frame.origin.x = xOrigin;
	frame.origin.y = 0;
	view.frame = frame;
    NSLog(@"%f, %f, %f, %f", self.view.frame.size.height, _scrollView.frame.size.height, frame.size.height, _scrollView.contentSize.height);
}

- (void)moveToPageAtIndex:(NSInteger)index animated:(BOOL)animated
{
	_pageIndex = index;
    
	[self enqueuePageViewAtIndex:index];
	
	[self loadScrollViewWithPage:index-1];
	[self loadScrollViewWithPage:index];
	[self loadScrollViewWithPage:index+1];
	
	[self updatePhotoInformation:index];
	[_scrollView scrollRectToVisible:((UIImageView *)[self.pages objectAtIndex:index]).frame animated:animated];
}

- (void)layoutScrollViewSubviews
{
	NSInteger index = [self centerPageIndex];
	
	for (NSInteger page = index-1; page < index+1; page++) {
		
		if (page >= 0 && page < [self.pages count]){
			
			CGFloat originX = _scrollView.bounds.size.width * page;
			
			if (page < index) {
				originX -= PAGE_GAP;
			}
			if (page > index) {
				originX += PAGE_GAP;
			}
			
			if ([self.pages objectAtIndex:page] == [NSNull null] || !((UIImageView *)[self.pages objectAtIndex:page]).superview){
				[self loadScrollViewWithPage:page];
			}
			
			UIImageView *view = (UIImageView *)[self.pages objectAtIndex:page];
			CGRect newframe = CGRectMake(originX, .0f, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
			
			if (!CGRectEqualToRect(view.frame, newframe)) {
				
				[UIView beginAnimations:nil context:NULL];
				[UIView setAnimationDuration:0.1];
				view.frame = newframe;
				[UIView commitAnimations];
                
			}
			
		}
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = [self centerPageIndex];
	if (index >= [self.pages count] || index < 0) {
		return;
	}
    
    if (_pageIndex != index && !_rotating) {
        
		_pageIndex = index;
		
		if (![_scrollView isTracking]) {
			[self layoutScrollViewSubviews];
		}
		
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_rotating) {
        return;
    }
    
	int index = [self centerPageIndex];
	if (index >= [self.pages count] || index < 0) {
		return;
	}
	
	[self moveToPageAtIndex:index animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _dragging = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    _dragging = NO;
}

- (void)dealloc {
    [_photos release];
    [_pages release];
    [super dealloc];
}

@end
