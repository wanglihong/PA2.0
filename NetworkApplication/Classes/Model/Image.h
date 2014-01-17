//
//  Image.h
//  Red-PA
//
//  Created by Dennis Yang on 12-9-11.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "ImageProtocol.h"
#import "People.h"

@interface Image : NSObject <ImageProtocol> {
    NSString *_imageId;         // 图片id
    NSString *_imageDate;       // 图片上传日期
    NSString *_imageVoiceId;    // 图片录音
    NSInteger _hasSupported;    // (是否:1\0)已赞过
    NSInteger _supportCount;    // 赞
    People *_people;            // 图片上传作者
}

@property (nonatomic, retain) NSString *imageId;
@property (nonatomic, retain, setter = set_imageDate:) NSString *imageDate;
@property (nonatomic, retain) NSString *imageVoiceId;
@property (nonatomic, retain) People *people;
@property NSInteger hasSupported;
@property NSInteger supportCount;

- (void)set_imageDate:(NSString *)imageDate;

@end
