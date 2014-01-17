//
//  BottomInputBar.h
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-28.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BottomInputBar;

@protocol BottomInputBarDelegate <NSObject>

@optional
- (void)bottomInputBar:(BottomInputBar *)bar didFinishInputVoice:(NSData *)voice;
- (void)bottomInputBar:(BottomInputBar *)bar didFinishInputText:(NSString *)text;

@end

@interface BottomInputBar : UIView <UITextViewDelegate> {
    
    id<BottomInputBarDelegate> _delegate;
    CGRect __keyboardRect;
}

@property (nonatomic, assign) id<BottomInputBarDelegate> delegate;

- (void)closeKeyboard;

@end
