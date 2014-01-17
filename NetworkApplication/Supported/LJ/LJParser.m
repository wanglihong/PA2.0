//
//  LJParser.m
//  NetworkApplication
//
//  Created by Dennis Yang on 12-10-29.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "LJParser.h"

#import "Party.h"
#import "Comment.h"

@implementation LJParser

static LJParser *_instance = nil;

+ (LJParser *)sharedParser {
    
    @synchronized(self){
		if (!_instance){
			_instance = [[LJParser alloc] init];
		}
	}
	
	return _instance;
}

- (NSMutableArray *)partiesWithData:(NSDictionary *)dic {
    
    NSMutableArray *allParty = [NSMutableArray arrayWithCapacity:0];
    NSArray *arr = [dic objectForKey:@"data"];
    
    for (int i = 0 ; i < arr.count; i++) {
        
        NSDictionary *d = [arr objectAtIndex:i];
        Party *p = [[Party alloc] init];
        p.partyId          = [d objectForKey:@"_id"];
        p.partyDate        = [d objectForKey:@"actived"];
        p.partyPlace       = [d objectForKey:@"address"];
        p.partyIntroduce   = [d objectForKey:@"description"];
        p.partyName        = [d objectForKey:@"name"];
        p.partyTitle       = [d objectForKey:@"title"];
        p.partyIconId      = [d objectForKey:@"icon"];
        p.partyJoined      = [[d objectForKey:@"join"] intValue];
        
        [allParty addObject:p];
        [p release];
    }
    
    return allParty;
}

- (Party *)partyWithData:(NSDictionary *)dic {
    
    NSDictionary *d = [dic objectForKey:@"data"];
    
    Party *p = [[[Party alloc] init] autorelease];
    p.partyId          = [d objectForKey:@"_id"];
    p.partyDate        = [d objectForKey:@"actived"];
    p.partyPlace       = [d objectForKey:@"address"];
    p.partyIntroduce   = [d objectForKey:@"description"];
    p.partyName        = [d objectForKey:@"name"];
    p.partyTitle       = [d objectForKey:@"title"];
    p.partyIconId      = [d objectForKey:@"icon"];
    p.partyJoined      = [[d objectForKey:@"join"] intValue];
    
    
    
    NSDictionary *entrepreneur = [d objectForKey:@"entrepreneur"];
    
    People *people = [[[People alloc] init] autorelease];
    people.peopleId = [entrepreneur objectForKey:@"_id"];
    people.peopleNickName = [entrepreneur objectForKey:@"name"];
    people.peopleHeaderURL = [entrepreneur objectForKey:@"icon"];
    people.peopleQQ = [entrepreneur objectForKey:@"qq"];;
    p.sponsor = people;
    
    
    
    NSArray *previous  = [d objectForKey:@"posters"];
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *d in previous) {
        
        Image *image = [[[Image alloc] init] autorelease];
        image.imageId = [d objectForKey:@"_id"];
        image.imageDate = [d objectForKey:@"uploadDate"];
        
        [images addObject:image];
    }
    p.partyPrevious = images;
    
    return p;
}

- (NSArray *)peoplesWithData:(NSDictionary *)dic {
    
    NSMutableArray *allPeople = [NSMutableArray arrayWithCapacity:0];
    NSArray *arr = [dic objectForKey:@"data"];
    
    for (int i = 0 ; i < arr.count; i++) {
        
        NSDictionary *d = [arr objectAtIndex:i];
        
        People *p = [[People alloc] init];
        
        p.peopleId          = [d objectForKey:@"_id"];
        p.peopleMobilePhone = [d objectForKey:@"mobile"];
        p.peopleNickName    = [d objectForKey:@"name"];
        p.peopleHeaderURL   = [d objectForKey:@"icon"];
        p.peopleRealName    = [d objectForKey:@"truename"];
        p.peopleUniversity  = [d objectForKey:@"university"];
        p.peopleDepartment  = [d objectForKey:@"dept"];
        p.peopleQQ          = [d objectForKey:@"qq"];
        p.peopleEmail       = [d objectForKey:@"email"];
        p.peopleInformation = [d objectForKey:@"description"];
        p.peopleGender      = [d objectForKey:@"gender"];
        
        [allPeople addObject:p];
        [p release];
    }
    
    return allPeople;
}

- (NSInteger)listLengthWithData:(NSDictionary *)dic {
    
    if ([dic isKindOfClass:[NSDictionary class]]) {
        
        return [[dic objectForKey:@"total"] intValue];
    }
    
    return 0;
}

- (NSArray *)photosWithData:(NSDictionary *)dic {
    
    NSMutableArray *allPhoto = [NSMutableArray arrayWithCapacity:0];
    NSArray *arr = [dic objectForKey:@"data"];
    
    for (int i = 0 ; i < arr.count; i++) {
        NSDictionary *d = [arr objectAtIndex:i];
        
        Image *m = [[Image alloc] init];
        
        m.imageId           = [d objectForKey:@"_id"];
        m.imageDate         = [d objectForKey:@"uploadDate"];
        m.hasSupported      = [[d objectForKey:@"good"] intValue];
        
        NSDictionary *meta = [d objectForKey:@"metadata"];
        
        m.imageVoiceId = [meta objectForKey:@"voice"];
        m.supportCount = [[meta objectForKey:@"good"] intValue];
        m.image_180 = [meta objectForKey:@"180"];
        m.image_360 = [meta objectForKey:@"360"];
        
        NSDictionary *user = [meta objectForKey:@"user"];
        
        People *p = [[People alloc] init];
        p.peopleId = [user objectForKey:@"id"];
        p.peopleNickName = [user objectForKey:@"name"];
        p.peopleHeaderURL = [user objectForKey:@"icon"];
        
        m.people = p;
        [p release];
        
        [allPhoto addObject:m];
        [m release];
    }
    
    return allPhoto;
}

- (People *)peopleWithData:(NSDictionary *)dic {
    
    NSDictionary *d = [dic objectForKey:@"data"];
    
    People *p = [[[People alloc] init] autorelease];
    
    p.peopleId = [d objectForKey:@"_id"];
    p.peopleNickName = [d objectForKey:@"name"];
    p.peopleRealName = [d objectForKey:@"truename"];
    p.peopleUniversity = [d objectForKey:@"university"];
    p.peopleDepartment = [d objectForKey:@"dept"]; //deptfaculty
    p.peopleQQ = [d objectForKey:@"qq"];
    p.peopleEmail = [d objectForKey:@"email"];
    p.peopleMobilePhone = [d objectForKey:@"mobile"];
    p.peopleHeaderURL = [d objectForKey:@"icon"];
    p.peopleInformation = [d objectForKey:@"description"];
    p.peopleEnterDate = [d objectForKey:@""];
    p.peopleGender = [d objectForKey:@"gender"];
    
    return p;
}

- (NSArray *)commentsWithData:(NSDictionary *)dic {
    
    NSMutableArray *allComments = [NSMutableArray arrayWithCapacity:0];
    NSArray *arr = [dic objectForKey:@"data"];
    
    for (NSDictionary *d in arr) {
        
        People *p = [[People alloc] init];
        NSDictionary *u = [d objectForKey:@"user"];
        
        p.peopleId          = [u objectForKey:@"_id"];
        p.peopleMobilePhone = [u objectForKey:@"mobile"];
        p.peopleNickName    = [u objectForKey:@"name"];
        p.peopleHeaderURL   = [u objectForKey:@"icon"];
        p.peopleRealName    = [u objectForKey:@"truename"];
        p.peopleUniversity  = [u objectForKey:@"university"];
        p.peopleDepartment  = [u objectForKey:@"dept"];//dept//faculty
        p.peopleQQ          = [u objectForKey:@"qq"];
        p.peopleEmail       = [u objectForKey:@"email"];
        p.peopleInformation = [u objectForKey:@"description"];
        p.peopleEnterDate   = [u objectForKey:@""];
        
        
        Comment *c = [[Comment alloc] init];
        
        c.people        = p;
        c.date          = [d objectForKey:@"created"];
        c.content       = [d objectForKey:@"comment"];
        c.imageId       = [d objectForKey:@"photo"];
        c.voiceId       = [d objectForKey:@"voice"];
        c.commentId     = [d objectForKey:@"_id"];
        c.length        = [[d objectForKey:@"voice_length"] intValue];
        
        [allComments addObject:c];
        [p release];
        [c release];
    }
    
    return allComments;
}

@end
