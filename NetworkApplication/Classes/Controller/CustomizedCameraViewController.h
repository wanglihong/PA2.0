//
//  CustomizedCameraViewController.h
//  NetworkApplication
//
//  Created by Dennis Yang on 13-1-18.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import "PartyViewController.h"

typedef enum {
    CameraMode = 1,
    LibraryMode = 2
} PhotoCaptureMode;

@interface CustomizedCameraViewController : PartyViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    UIImagePickerController *_imagePicker;
    PhotoCaptureMode captureMode;
}

@property (retain, nonatomic) IBOutlet UIImageView *liveView;
@property (retain, nonatomic) IBOutlet UIView *_camera_bar_1;
@property (retain, nonatomic) IBOutlet UIView *_camera_bar_2;

@end
