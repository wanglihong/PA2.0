//
//  PhotoViewer.m
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-13.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "PhotoViewer.h"
#import "Image.h"

@implementation PhotoViewer

@synthesize photos = _photos;
@synthesize pages = _pages;
@synthesize pageIndex = _pageIndex;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.pagingEnabled = YES;
    }
    return self;
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
	CGSize contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
	contentSize.width = (contentSize.width * [self.pages count]);
    contentSize.height = self.bounds.size.height;
	
	if (!CGSizeEqualToSize(contentSize, self.contentSize)) {
		self.contentSize = contentSize;
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
    CGFloat pageWidth = self.frame.size.width;
	return floor((self.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}

- (void)loadScrollViewWithPage:(int)page
{
#define PAGE_GAP 20
    if (page < 0) return;
    if (page >= [self.pages count]) return;
    
    UIImageView *view = (UIImageView *)[self.pages objectAtIndex:page];
    
    if ((NSNull*)view == [NSNull null]) {
		
        Image *img = [self.photos objectAtIndex:page];
        
        view = [[UIImageView alloc] initWithFrame:[self frame]];
        view.contentMode = UIViewContentModeScaleAspectFit;
        view.clipsToBounds = YES;
        [view setImageWithURL:[NSURL URLWithString:IMAGE(img.imageId)]];
		[self.pages replaceObjectAtIndex:page withObject:view];
        [view release];
	}
	
    if (nil == view.superview) {
        [self addSubview:view];
    }
    
    CGRect frame = self.frame;
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
}

- (void)moveToPageAtIndex:(NSInteger)index animated:(BOOL)animated
{
	_pageIndex = index;
    
	[self enqueuePageViewAtIndex:index];
	
	[self loadScrollViewWithPage:index-1];
	[self loadScrollViewWithPage:index];
	[self loadScrollViewWithPage:index+1];
	
	
	[self scrollRectToVisible:((UIImageView *)[self.pages objectAtIndex:index]).frame animated:animated];
}

- (void)layoutScrollViewSubviews
{
	NSInteger index = [self centerPageIndex];
	
	for (NSInteger page = index-1; page < index+1; page++) {
		
		if (page >= 0 && page < [self.pages count]){
			
			CGFloat originX = self.bounds.size.width * page;
			
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
			CGRect newframe = CGRectMake(originX, .0f, self.bounds.size.width, self.bounds.size.height);
			
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
		
		if (![self isTracking]) {
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

@end
