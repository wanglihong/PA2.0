//
//  PersonalSettingViewController.h
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-17.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "PartyViewController.h"
#import "WBEngine.h"
#import "WBLogInAlertView.h"

@interface PersonalSettingViewController : PartyViewController <WBEngineDelegate> {
    WBEngine *engine;
}

@end
