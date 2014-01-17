//
//  GridViewItem.m
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-4.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "GridViewItem.h"

@implementation GridViewItem

@synthesize shadow;
@synthesize imageView;
@synthesize delegate;
@synthesize index;

- (id)initWithFrame:(CGRect)frame {
    
    if (self == [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        /*
        shadow = [[UIImageView alloc] initWithFrame:CGRectMake(-4, -4, frame.size.width + 8, frame.size.height + 8)];
        [self addSubview:shadow];
        [shadow release];*/
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        //imageView.alpha = 0.85;
        [self addSubview:imageView];
        [imageView release];
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    if (touch.tapCount == 1) {
        
        UIView *hightLight = [[[UIView alloc] initWithFrame:self.bounds] autorelease];
        hightLight.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.75];
        hightLight.tag = 100;
        [self addSubview:hightLight];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    [self performSelector:@selector(cancelHighLight) withObject:nil afterDelay:0.2];
    
    if (touch.tapCount == 1) {
        
        [self performSelector:@selector(handelTouch) withObject:nil afterDelay:0.2];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self performSelector:@selector(cancelHighLight) withObject:nil afterDelay:0.2];
}

- (void)cancelHighLight
{
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDidStopSelector:@selector(removeHighLight)];
    
    [[self viewWithTag:100] setAlpha:0];
    
    [UIView commitAnimations];
}

- (void)removeHighLight
{
    [[self viewWithTag:100] removeFromSuperview];
}

- (void)handelTouch
{
    if ([delegate respondsToSelector:@selector(gridViewItem:didSelectedItemAtIndex:)]) {
        [delegate gridViewItem:self didSelectedItemAtIndex:self.index];
    }
}

- (void)dealloc {
    [imageView cancelCurrentImageLoad];
    [shadow removeFromSuperview];
    shadow = nil;
    [imageView removeFromSuperview];
    imageView = nil;
    [super dealloc];
}

@end
