//
//  ShareViewController.h
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-20.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "PartyViewController.h"

#import <MessageUI/MessageUI.h>

#import "WXApi.h"

#import "WBEngine.h"
#import "WBLogInAlertView.h"

@interface ShareViewController : PartyViewController
    <UIActionSheetDelegate,
    MFMailComposeViewControllerDelegate,
    MFMessageComposeViewControllerDelegate,
    WBEngineDelegate, WXApiDelegate> {
        
    WBEngine *weiBoEngine;
    UIImage *_share_image;
}

- (void)share;

@end
