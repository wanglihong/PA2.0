//
//  AudioPlayer.m
//  SpeakHere
//
//  Created by Dennis Yang on 12-12-27.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "AudioPlayer.h"

#import "dec_if.h"
#import "interf_dec.h"
#import "interf_enc.h"
#import "amrFileCodec.h"

@implementation AudioPlayer

- (id)init {
    self = [super init];
    if (self) {
        //Instanciate an instance of the AVAudioSession object.
        AVAudioSession * audioSession = [AVAudioSession sharedInstance];
        //Setup the audioSession for playback and record.
        //We could just use record and then switch it to playback leter, but
        //since we are going to do both lets set it up once.
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    return self;
}

static AudioPlayer *_instance = nil;

+ (AudioPlayer *)player {
    
    @synchronized(self){
		if (!_instance){
			_instance = [[AudioPlayer alloc] init];
		}
	}
	
	return _instance;
}

+ (void)loudSpeaker:(bool)bOpen {
    UInt32 route;
    OSStatus error;
    UInt32 sessionCategory = kAudioSessionCategory_PlayAndRecord;
    
    error = AudioSessionSetProperty (
                                     kAudioSessionProperty_AudioCategory,
                                     sizeof (sessionCategory),
                                     &sessionCategory
                                     );
    
    route = bOpen?kAudioSessionOverrideAudioRoute_Speaker:kAudioSessionOverrideAudioRoute_None;
    error = AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(route), &route);
}

- (void)play_amr:(NSData *)file {
    NSData *__wav = DecodeAMRToWAVE(file);
    [self startPlay:__wav];
}

- (void)play_amr:(NSData *)amr sender:(UIButton *)btn {
    
    BOOL pause = NO;
    
    if (player.isPlaying) {
        
        if (sender == btn)
            
            pause = YES;
        
        [self stopPlay];
        
    }
    
    if (!pause) {
        sender = [btn retain];
        NSData *__wav = DecodeAMRToWAVE(amr);
        [self startPlay:__wav];
    }
    
}

- (void)startPlay:(NSData *)file {
    
    NSError *error;
    player = [[AVAudioPlayer alloc] initWithData:file error:&error];
    //player.volume = 0.5;
    //player.meteringEnabled=YES;
    //player.numberOfLoops= 0;
    player.delegate=self;
    
    if(player == nil) {
        NSLog(@"Cant not play this sound file.");
        
    } else {
        sender.selected = YES;
        [player play];
        [AudioPlayer loudSpeaker:YES];
    }
}

- (void)stopPlay {
    
    [player stop];
    [player release];
    player = nil;
    
    sender.selected = NO;
    [sender release];
    sender = nil;
}

#pragma mark - AudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player
                       successfully:(BOOL)flag {
    [self stopPlay];
}

@end
