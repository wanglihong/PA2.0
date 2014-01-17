//
//  LJRequester.m
//  NetworkApplication
//
//  Created by Dennis Yang on 12-10-29.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "LJRequester.h"
#import "LocalData.h"

@implementation LJRequester {
    dispatch_queue_t callbackQueue;
    //void (^callback)(NSDictionary *dic);
    RKJSONParserJSONKit *_parser;
}

@synthesize callback;

static LJRequester *_instance = nil;

+ (LJRequester *)sharedRequester {
    
    @synchronized(self){
		if (!_instance){
			_instance = [[LJRequester alloc] init];
		}
	}
	
	return _instance;
}

- (id)init {
    self = [super init];
    if (self)
    {
        _parser = [[RKJSONParserJSONKit alloc] init];
        [RKClient clientWithBaseURLString:_base_url];
        [[RKClient sharedClient] setCachePolicy:RKRequestCachePolicyDefault];
        callbackQueue = dispatch_queue_create("callback queue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)partyListFromPosition:(int)pos withLength:(int)len {
    [[RKClient sharedClient] get:[NSString stringWithFormat:@"/party?offset=%d&limit=%d", pos, len]
                        delegate:self];
}

- (void)partyDetail:(NSString *)pId {
    [[RKClient sharedClient] get:[NSString stringWithFormat:@"/party/%@", pId]
                        delegate:self];
}

- (void)memberListOfParty:(NSString *)pId fromPosition:(int)pos withLength:(int)len {
    [[RKClient sharedClient] get:[NSString stringWithFormat:@"/party/%@/user?offset=%d&limit=%d", pId, pos, len]
                        delegate:self];
}

- (void)photoListOfParty:(NSString *)pId fromPosition:(int)pos withLength:(int)len {
    [[RKClient sharedClient] get:[NSString stringWithFormat:@"/party/%@/photo?offset=%d&limit=%d", pId, pos, len]
                        delegate:self];
}

- (void)loginWithUserName:(NSString *)name andPassword:(NSString *)pass {
    [[RKClient sharedClient] post:@"/login"
                           params:[NSDictionary dictionaryWithObjectsAndKeys: name, @"mobile", pass, @"password", nil]
                         delegate:self];
}

- (void)updatePeopleInformation:(NSDictionary *)dic {
    [[RKClient sharedClient] put:@"/user"
                          params:dic
                        delegate:self];
}

- (void)updatePeopleHeaderIcon:(UIImage *)icon {
    RKParams *params = [RKParams params];
    [params setData:UIImageJPEGRepresentation(icon, 1.0) MIMEType:@"image/png" forParam:@"image"];
    
    [[RKClient sharedClient] post:@"/user/icon"
                           params:params
                         delegate:self];
}

- (void)chagePassword:(NSString *)old newPassword:(NSString *)_new {
    [[RKClient sharedClient] post:@"/password"
                           params:[NSDictionary dictionaryWithObjectsAndKeys:old, @"oldpassword", _new, @"password", nil]
                         delegate:self];
}

- (void)logout {
    [[RKClient sharedClient] post:@"/logout"
                           params:nil
                         delegate:self];
}

- (void)uploadPhoto:(UIImage *)photo {
    RKParams *params = [RKParams params];
    [params setData:UIImageJPEGRepresentation(photo, 1.0) MIMEType:@"image/png" forParam:@"image"];
    
    [[RKClient sharedClient] post:[NSString stringWithFormat:@"/party/%@/photo", [LocalData data].currentParty.partyId]
                           params:params
                         delegate:self];
}

- (void)uploadPhoto:(UIImage *)photo voice:(NSData *)voi {
    RKParams *params = [RKParams params];
    [params setData:UIImageJPEGRepresentation(photo, 1.0) MIMEType:@"image/png" forParam:@"image"];
    [params setData:voi MIMEType:@"audio/mpeg" forParam:@"voice"];
    
    [[RKClient sharedClient] post:[NSString stringWithFormat:@"/party/%@/photo", [LocalData data].currentParty.partyId]
                           params:params
                         delegate:self];
}

- (void)commentsOfPhoto:(NSString *)pId fromPosition:(int)pos withLength:(int)len {
    [[RKClient sharedClient] get:[NSString stringWithFormat:@"/photo/%@/comment?offset=%d&limit=%d", pId, pos, len]
                        delegate:self];
}

- (void)sendPhotoComment:(NSString *)pId comment:(NSString *)tex {
    RKParams *params = [RKParams params];
    [params setData:[tex dataUsingEncoding:NSUTF8StringEncoding] forParam:@"comment"];
    
    [[RKClient sharedClient] post:[NSString stringWithFormat:@"/photo/%@/comment", pId]
                           params:params
                         delegate:self];
}

- (void)sendPhotoComment:(NSString *)pId voice:(NSData *)voi {
    RKParams *params = [RKParams params];
    [params setData:voi MIMEType:@"audio/mpeg" forParam:@"voice"];
    
    [[RKClient sharedClient] post:[NSString stringWithFormat:@"/photo/%@/comment", pId]
                           params:params
                         delegate:self];
}

- (void)sendPhotoComment:(NSString *)pId voice:(NSData *)voi length:(NSInteger)len {
    RKParams *params = [RKParams params];
    [params setData:voi MIMEType:@"audio/mpeg" forParam:@"voice"];
    [params setValue:[NSString stringWithFormat:@"%d", len] forParam:@"voice_length"];
    
    [[RKClient sharedClient] post:[NSString stringWithFormat:@"/photo/%@/comment", pId]
                           params:params
                         delegate:self];
}

- (void)joinParty:(NSString *)pId {
    [[RKClient sharedClient] get:[NSString stringWithFormat:@"/party/%@/join", pId]
                        delegate:self];
}

- (void)addGood:(NSString *)mId {
    [[RKClient sharedClient] get:[NSString stringWithFormat:@"/photo/%@/good", mId]
                        delegate:self];
}

- (void)getVerifyCode:(NSString *)mobile {
    NSDictionary *params = [NSDictionary dictionaryWithObject:mobile forKey:@"mobile"];
    [[RKClient sharedClient] post:@"/application"
                           params:params
                         delegate:self];
}

- (void)registerWithMobile:(NSString *)mob pass:(NSString *)psd verify:(NSString *)cod {
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            cod, @"code",
                            psd, @"password",
                            mob, @"name",       nil];
    [[RKClient sharedClient] post:@"/register"
                           params:params
                         delegate:self];
}

- (void)getPassword:(NSString *)mobile {
    NSDictionary *params = [NSDictionary dictionaryWithObject:mobile forKey:@"mobile"];
    [[RKClient sharedClient] post:@"/forgetpassword"
                           params:params
                         delegate:self];
}

#pragma mark - RKObjectLoaderDelegate

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSLog(@"request error getted: %@", [error localizedDescription]);
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSLog(@"response status code: %d", [response statusCode]);
    NSLog(@"response body string: %@", [response bodyAsString]);
    
    NSDictionary *dic = [_parser objectFromString:[response bodyAsString] error:nil];
    dispatch_async(dispatch_get_main_queue(), ^{callback(dic);});
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
    NSLog(@"success load objects: %d", [objects count]);
}

- (void)dealloc {
    dispatch_release(callbackQueue);
    [_parser release];
    Block_release(callback);
    [super dealloc];
}

@end
