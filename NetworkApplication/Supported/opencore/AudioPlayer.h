//
//  AudioPlayer.h
//  SpeakHere
//
//  Created by Dennis Yang on 12-12-27.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface AudioPlayer : NSObject <AVAudioPlayerDelegate> {
    AVAudioPlayer *player;
    UIButton *sender;
    
    BOOL playing;
}

+ (AudioPlayer *)player;

- (void)play_amr:(NSData *)file;

- (void)play_amr:(NSData *)amr sender:(UIButton *)btn;

- (void)startPlay:(NSData *)file;

- (void)stopPlay;

@end
