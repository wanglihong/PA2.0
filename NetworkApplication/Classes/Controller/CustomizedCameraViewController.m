//
//  CustomizedCameraViewController.m
//  NetworkApplication
//
//  Created by Dennis Yang on 13-1-18.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import "CustomizedCameraViewController.h"

#import "CameraImageHelper.h"

#import "AudioRecorder.h"

#import "dec_if.h"
#import "interf_dec.h"
#import "interf_enc.h"
#import "amrFileCodec.h"

@interface CustomizedCameraViewController () {
    NSData *AMR;
}

@end

@implementation CustomizedCameraViewController

@synthesize liveView;
@synthesize _camera_bar_1;
@synthesize _camera_bar_2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self performSelector:@selector(openCamera) withObject:nil afterDelay:0.5];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    [CameraImageHelper embedPreviewInView:self.liveView];
    captureMode = CameraMode;
}

- (void)viewWillAppear:(BOOL)animated {NSLog(@"viewWillAppear");
    [super viewWillAppear:animated];
    
    [self setWantsFullScreenLayout:YES];
    [self performSelector:@selector(openCamera) withObject:nil afterDelay:0.5];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    [[CameraImageHelper sharedInstance] preview].frame = self.liveView.bounds;
}

- (void)viewWillDisappear:(BOOL)animated {NSLog(@"viewWillDisappear");
    [super viewWillDisappear:animated];
    
    [self setWantsFullScreenLayout:NO];
    [self performSelector:@selector(closeCamera) withObject:nil afterDelay:0.5];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    [liveView setImage:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [CameraImageHelper clear];
    [_imagePicker release];
    
    if (AMR) {
        [AMR release], AMR = nil;
    }
    
    [liveView release];
    [_camera_bar_1 release];
    [_camera_bar_2 release];
    [super dealloc];
}

#pragma mark
#pragma mark - Private Methods

- (void)openCamera {
    [CameraImageHelper startRunning];
}

- (void)closeCamera {
    [CameraImageHelper stopRunning];
}

- (IBAction)startRecord {
    [[AudioRecorder recorder] startRecord];
}

- (IBAction)stopRecord {
    NSString *file = [[AudioRecorder recorder] stopRecord].relativePath;
    NSLog(@"amr file path: %@", file);
    
    NSData *__amr = EncodeWAVEToAMR([NSData dataWithContentsOfFile:file], 1, 16);
    NSLog(@"amr file length: %d", __amr.length);
    
    if (__amr.length < 2048) {
        [SVProgressHUD showErrorWithStatus:@"录音时间太短！"];
        return;
    }
    
    AMR = [__amr retain];
}

- (IBAction)cancel:(id)sender {
    [TABBAR_VIEW_CONTROLLER selectItemAtIndex:0];
    [self dismissModalViewControllerAnimated:NO];
}

- (IBAction)snapPressed:(id)sender {
    [CameraImageHelper CaptureStillImage];
    [CameraImageHelper stopRunning];
    captureMode = CameraMode;
    
    [UIView animateWithDuration:.25
                     animations:^{
                         [_camera_bar_1 setAlpha:0];
                         [_camera_bar_2 setAlpha:1];
                     }
                     completion:^(BOOL finished) {
        
                     }];
}

- (IBAction)backPressed:(id)sender {
    [[[CameraImageHelper sharedInstance] preview] setHidden:NO];
    captureMode = CameraMode;
    
    [UIView animateWithDuration:.25
                     animations:^{
                         [_camera_bar_1 setAlpha:1];
                         [_camera_bar_2 setAlpha:0];
                     }
                     completion:^(BOOL finished) {
                         [CameraImageHelper startRunning];
                     }];
}

- (IBAction)optionPressed:(id)sender {
    captureMode = LibraryMode;
    
    if (!_imagePicker) {
        [SVProgressHUD showWithStatus:@"Loading..."];
        [NSThread detachNewThreadSelector:@selector(initImagePickerController) toTarget:self withObject:nil];
    } else {
        [self presentPhotoLibraryViewController];
    }
}

- (IBAction)uploadPressed:(id)sender {
    if (![[LocalData data] currentPeople]) {
        //[super presentLoginViewController];
        [SVProgressHUD showErrorWithStatus:@"登录后才能上传照片!"];
        
    } else {
        [__requester setCallback:^(NSDictionary *dic) {
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            
            [[[CameraImageHelper sharedInstance] preview] setHidden:NO];
            [[[CameraImageHelper sharedInstance] preview] setContents:nil];
            self.liveView.image = nil;
            [LocalData data].HAVE_NEW_PHOTO = YES;
            
            [UIView animateWithDuration:.25
                             animations:^{
                                 [_camera_bar_1 setAlpha:1];
                                 [_camera_bar_2 setAlpha:0];
                             }
                             completion:^(BOOL finished) {
                                 [CameraImageHelper startRunning];
                             }];
        }];
        
        if (AMR) {
            [__requester uploadPhoto:(captureMode == CameraMode ? [CameraImageHelper image] : liveView.image) voice:AMR];
            [AMR release], AMR = nil;
            
        } else {
            [__requester uploadPhoto:(captureMode == CameraMode ? [CameraImageHelper image] : liveView.image)];
        }
        
        [SVProgressHUD showWithStatus:@"上传照片..."];
    }
}


- (void)initImagePickerController {
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.delegate = self;
    _imagePicker.allowsEditing = YES;
    _imagePicker.videoQuality = UIImagePickerControllerQualityTypeLow;
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self performSelectorOnMainThread:@selector(didFinishInitImagePickerController) withObject:nil waitUntilDone:YES];
    
    [pool release];
}

- (void)didFinishInitImagePickerController {
    [SVProgressHUD dismiss];
    [self presentPhotoLibraryViewController];
}

- (void)presentPhotoLibraryViewController {
    [self.view addSubview:_imagePicker.view];
    [_imagePicker.view setFrame:CGRectMake(0, _imagePicker.view.frame.size.height,
                                         _imagePicker.view.frame.size.width, _imagePicker.view.frame.size.height)];
    [UIView animateWithDuration:.25
                     animations:^{
                         [_imagePicker.view setFrame:CGRectMake(0, 0, _imagePicker.view.frame.size.width,
                                                              _imagePicker.view.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                         [CameraImageHelper stopRunning];
                     }];
}

- (void)dismissPhotoLibraryViewController {
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         [_imagePicker.view setFrame:CGRectMake(0, _imagePicker.view.frame.size.height,
                                                                _imagePicker.view.frame.size.width, _imagePicker.view.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                         [_imagePicker.view removeFromSuperview];
                     }];
}

#pragma mark 
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissPhotoLibraryViewController];
    
    [[[CameraImageHelper sharedInstance] preview] setHidden:NO];
    [CameraImageHelper startRunning];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissPhotoLibraryViewController];
    
    [[[CameraImageHelper sharedInstance] preview] setHidden:YES];
    [liveView setImage:[info valueForKey:UIImagePickerControllerEditedImage]];
    
    [UIView animateWithDuration:.25
                     animations:^{
                         [_camera_bar_1 setAlpha:0];
                         [_camera_bar_2 setAlpha:1];
                     }
                     completion:^(BOOL finished) {
                         [CameraImageHelper stopRunning];
                     }];
}

@end
