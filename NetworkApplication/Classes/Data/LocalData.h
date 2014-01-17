//
//  LocalData.h
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-10.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "Party.h"
#import "People.h"

@interface LocalData : NSObject {
    Party *currentParty;
    People *currentPeople;
}

@property (nonatomic, retain) Party *currentParty;
@property (nonatomic, retain) People *currentPeople;

@property BOOL USER_LOGIN_STATUS_CHANGED;
@property BOOL USER_INFORMATION_CHANGED;
@property BOOL HAVE_NEW_PHOTO;

+ (LocalData *)data;

@end
