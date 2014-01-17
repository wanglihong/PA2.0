//
//  WritingToolbar.h
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-24.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WritingToolbar;

@protocol WritingToolbarDelegate <NSObject>

- (void)writingToolbar:(WritingToolbar *)toolbar willSendText:(NSString *)text;
- (void)writingToolbar:(WritingToolbar *)toolbar willSendSound:(NSData  *)data;

@end

@interface WritingToolbar : UIView <UITextViewDelegate> {
    UITextView *_inputField;
    id <WritingToolbarDelegate> _delegate;
}

@property (nonatomic, assign) UITextView *inputField;
@property (nonatomic, assign) id <WritingToolbarDelegate> delegate;

@end
