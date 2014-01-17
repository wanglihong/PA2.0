//
//  ImageProtocol.h
//  NetworkApplication
//
//  Created by Dennis Yang on 12-12-18.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ImageProtocol <NSObject>

@property (nonatomic, retain) NSString *imageId;
@property (nonatomic, retain) NSString *image_180;
@property (nonatomic, retain) NSString *image_360;
@property (nonatomic, retain) NSString *image_720;

@end
