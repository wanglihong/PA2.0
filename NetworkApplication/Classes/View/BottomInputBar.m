//
//  BottomInputBar.m
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-28.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "BottomInputBar.h"
#import "AudioRecorder.h"

#import "dec_if.h"
#import "interf_dec.h"
#import "interf_enc.h"
#import "amrFileCodec.h"

#define __TEXTVIEW_TAG 9999
#define __TEXTVIEW_BG_TAG 9998

@implementation BottomInputBar

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification object:nil];
#ifdef __IPHONE_5_0
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (version >= 5.0) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                         name:UIKeyboardWillChangeFrameNotification object:nil];
        }
#endif
        
        [self setInputTypeAsVoice];
    }
    return self;
}

- (void)addShadow {
    UIImageView *shadows = [[UIImageView alloc] initWithFrame:CGRectMake(0, -5, self.frame.size.width, 5)];
    shadows.image = [UIImage imageNamed:@"shadows_bottom.png"];
    [self addSubview:shadows];
    [shadows release];
    
    UILabel *white = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    white.backgroundColor = [UIColor colorWithWhite:1 alpha:.5];
    [self addSubview:white];
    [white release];
}

- (void)setInputTypeAsVoice {
    [self closeKeyboard];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self addShadow];
    
    UIButton *tex = [UIButton buttonWithType:UIButtonTypeCustom];
    [tex setFrame:CGRectMake(0, 2, 45, 38)];
    [tex setImage:[UIImage imageNamed:@"feeddetail_toolbar_text_btn"] forState:UIControlStateNormal];
    [tex setImage:[UIImage imageNamed:@"feeddetail_toolbar_text_btn_h"] forState:UIControlStateHighlighted];
    [tex addTarget:self action:@selector(setInputTypeAsText) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:tex];
    
    UIButton *voice = [UIButton buttonWithType:UIButtonTypeCustom];
    [voice setFrame:CGRectMake(50, 6, 247, 35)];
    [voice.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [voice setTitle:@"按住评论" forState:UIControlStateNormal];
    [voice setTitle:@"松开结束" forState:UIControlStateSelected];
    [voice setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [voice setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [voice setBackgroundImage:[UIImage imageNamed:@"feeddetail_toolbar_audio_btn"] forState:UIControlStateNormal];
    [voice setBackgroundImage:[UIImage imageNamed:@"feeddetail_toolbar_audio_btn_h"] forState:UIControlStateHighlighted];
    [voice addTarget:self action:@selector(startRecord) forControlEvents:UIControlEventTouchDown];
    [voice addTarget:self action:@selector(stopRecord) forControlEvents:UIControlEventTouchUpInside];
    [voice addTarget:self action:@selector(stopRecord) forControlEvents:UIControlEventTouchUpOutside];
    [self addSubview:voice];
}

- (void)setInputTypeAsText {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self addShadow];
    
    UIButton *voi = [UIButton buttonWithType:UIButtonTypeCustom];
    [voi setFrame:CGRectMake(0, 2, 45, 38)];
    [voi setImage:[UIImage imageNamed:@"feeddetail_toolbar_phone_btn"] forState:UIControlStateNormal];
    [voi setImage:[UIImage imageNamed:@"feeddetail_toolbar_phone_btn_h"] forState:UIControlStateHighlighted];
    [voi addTarget:self action:@selector(setInputTypeAsVoice) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:voi];
    
    UIImageView *bg = [[[UIImageView alloc] init] autorelease];
    [bg setFrame:CGRectMake(50, 6, 247, 35)];
    [bg setTag:__TEXTVIEW_BG_TAG];
    [bg setImage:STRETCH_ABLE_IMAGE(@"feeddetail_toolbar_text_bg.png", 100, 17)];
    [self addSubview:bg];
    
    UITextView *text = [[[UITextView alloc] init] autorelease];
    [text setFrame:CGRectMake(55, 7, 247, 30)];
    [text setTag:__TEXTVIEW_TAG];
    [text setFont:[UIFont systemFontOfSize:14.0]];
    [text setBackgroundColor:[UIColor clearColor]];
    [text setReturnKeyType:UIReturnKeySend];
    [text becomeFirstResponder];
    [text setScrollEnabled:NO];
    [text setDelegate:self];
    [self addSubview:text];
    
    [self openKeyboard];
}

- (void)openKeyboard {
    UITextView *text = (UITextView *)[self viewWithTag:__TEXTVIEW_TAG];
    if (text)
        [text becomeFirstResponder];
}

- (void)closeKeyboard {
    UITextView *text = (UITextView *)[self viewWithTag:__TEXTVIEW_TAG];
    if (text)
        [text resignFirstResponder];
}

- (void)startRecord {
    [[AudioRecorder recorder] startRecord];
}

- (void)stopRecord {
    NSString *file = [[AudioRecorder recorder] stopRecord].relativePath;
    NSLog(@"amr file path: %@", file);
    
    NSData *__amr = EncodeWAVEToAMR([NSData dataWithContentsOfFile:file], 1, 16);
    NSLog(@"amr file length: %d", __amr.length);
    
    if ([_delegate respondsToSelector:@selector(bottomInputBar:didFinishInputVoice:)]) {
        [_delegate bottomInputBar:self didFinishInputVoice:__amr];
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        
        if ([_delegate respondsToSelector:@selector(bottomInputBar:didFinishInputText:)]) {
            [_delegate bottomInputBar:self didFinishInputText:textView.text];
        }
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    // 默认情况下: bg=35, textView=30
    CGSize size = [textView.text sizeWithFont:textView.font
                            constrainedToSize:CGSizeMake(textView.frame.size.width - 14, 1000.0f)
                                lineBreakMode:UILineBreakModeWordWrap];
    
    NSLog(@"_________________%f", size.height);
    // 在一行的情况下: size.height=18 那么textView bg的height应该为 35－18＝17
    // textView 的height 应该为 30-18=12
    // self 的 height 应该为 44－18＝26
    // 状态栏 和 导航栏 的高度 20+44=64
    UIView *v = [self viewWithTag:__TEXTVIEW_BG_TAG];
    if (size.height > 0) {NSLog(@"%f", __keyboardRect.origin.y);
        
        // 重设输入框的高度和位置
        [v setFrame:CGRectMake(v.frame.origin.x, v.frame.origin.y, v.frame.size.width, size.height + 17)];
        [textView setFrame:CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, size.height + 12)];
        // 重设整个输入栏的高度和位置
        [self setFrame:CGRectMake(0, __keyboardRect.origin.y - (size.height + 26) - 64, self.frame.size.width, size.height + 26)];
    }
}

#pragma mark -
#pragma mark Responding to keyboard events

- (void)keyboardWillShow:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    __keyboardRect = keyboardRect;
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, keyboardRect.origin.y - self.frame.size.height - 64, self.frame.size.width, self.frame.size.height);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, self.superview.frame.size.height - 44, self.frame.size.width, 44);
    }];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end
