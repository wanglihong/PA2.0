//
//  WritingToolbar.m
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-24.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "WritingToolbar.h"

@implementation WritingToolbar

@synthesize inputField = _inputField;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        
        UIImageView *_input_bg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 6, frame.size.width - 10*2 - 50, 31)];
        _input_bg.image = [[UIImage imageNamed:@"input-frame.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
        _input_bg.userInteractionEnabled = YES;
        [self addSubview:_input_bg];
        [_input_bg release];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(350, 6, 50, 31);
        [btn setTitle:@"语音" forState:UIControlStateNormal];
        [btn setTitle:@"键盘" forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(changeBarStyle:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        _inputField = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width - 10*2 - 50, 31)];
        _inputField.backgroundColor = [UIColor clearColor];
        _inputField.returnKeyType = UIReturnKeySend;
        _inputField.delegate = self;
        [_input_bg addSubview:_inputField];
    }
    return self;
}

- (void)changeBarStyle:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    btn.selected = !btn.selected;
}

#pragma mark - UITextViewDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        
        if ([_delegate respondsToSelector:@selector(writingToolbar:willSendText:)]) {
            [_delegate writingToolbar:self willSendText:textView.text];
        }
        return NO;
    }
    return YES;
}

- (void)dealloc {
    [_inputField release];
    [super dealloc];
}

@end
