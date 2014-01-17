//
//  LJParser.h
//  NetworkApplication
//
//  Created by Dennis Yang on 12-10-29.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "Party.h"
#import "Image.h"
#import "People.h"

@interface LJParser : NSObject

+ (LJParser *)sharedParser;

- (NSMutableArray *)partiesWithData:(NSDictionary *)dic;
- (Party *)partyWithData:(NSDictionary *)dic;
- (NSArray *)peoplesWithData:(NSDictionary *)dic;
- (NSInteger)listLengthWithData:(NSDictionary *)dic;
- (NSArray *)photosWithData:(NSDictionary *)dic;
- (People *)peopleWithData:(NSDictionary *)dic;
- (NSArray *)commentsWithData:(NSDictionary *)dic;

@end
