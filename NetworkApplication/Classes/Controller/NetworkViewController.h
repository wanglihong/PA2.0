//
//  NetworkViewController.h
//  NetworkApplication
//
//  Created by Dennis Yang on 12-10-29.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "LJRequester.h"
#import "LJParser.h"
#import "Tools.h"
#import "LocalData.h"
#import "Constants.h"
#import "GridViewItem.h"

#import "AppDelegate.h"

#define __requester [LJRequester sharedRequester]
#define __parser [LJParser sharedParser]

@interface NetworkViewController : UIViewController {
    LJRequester *_requester;
    __block LJParser *_parser;
}

@end
