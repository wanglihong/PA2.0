//
//  AudioRecorder.h
//  SpeakHere
//
//  Created by Dennis Yang on 12-12-27.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface AudioRecorder : NSObject <AVAudioRecorderDelegate, AVAudioSessionDelegate> {
    AVAudioRecorder *recorder;
    NSURL *recordedTmpFile;
    NSError *error;
    
    BOOL recording;
    UIView *levelBackground;
    UIImageView *level;
    NSTimer *levelTimer;
}

+ (AudioRecorder *)recorder;

- (void)startRecord;
- (NSURL *)stopRecord;

@end
