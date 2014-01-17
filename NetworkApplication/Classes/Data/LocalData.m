//
//  LocalData.m
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-10.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "LocalData.h"

@implementation LocalData

@synthesize currentParty;
@synthesize currentPeople;

@synthesize USER_LOGIN_STATUS_CHANGED;
@synthesize USER_INFORMATION_CHANGED;
@synthesize HAVE_NEW_PHOTO;

static LocalData *_instance = nil;

+ (LocalData *)data {
    
    @synchronized(self){
		if (!_instance){
			_instance = [[LocalData alloc] init];
		}
	}
	
	return _instance;
}

- (void)dealloc {
    [currentParty release];
    [currentPeople release];
    [super dealloc];
}

@end
