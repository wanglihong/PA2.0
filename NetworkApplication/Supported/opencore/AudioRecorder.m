//
//  AudioRecorder.m
//  SpeakHere
//
//  Created by Dennis Yang on 12-12-27.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

#import "AudioRecorder.h"

@implementation AudioRecorder

- (id)init {
    self = [super init];
    if (self) {
        //Instanciate an instance of the AVAudioSession object.
        AVAudioSession * audioSession = [AVAudioSession sharedInstance];
        //Setup the audioSession for playback and record.
        //We could just use record and then switch it to playback leter, but
        //since we are going to do both lets set it up once.
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: &error];
        
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
								 sizeof (audioRouteOverride),
								 &audioRouteOverride);
        
        //Activate the session
        [audioSession setActive:YES error: &error];
    }
    
    return self;
}

static AudioRecorder *_instance = nil;

+ (AudioRecorder *)recorder {
    
    @synchronized(self){
		if (!_instance){
			_instance = [[AudioRecorder alloc] init];
		}
	}
	
	return _instance;
}

- (void)startRecord {
    //Begin the recording session.
    //Error handling removed.  Please add to your own code.
    
    //Setup the dictionary object with all the recording settings that this
    //Recording sessoin will use
    //Its not clear to me which of these are required and which are the bare minimum.
    //This is a good resource: http://www.totodotnet.net/tag/avaudiorecorder/
    
    NSDictionary *recordSetting = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                   [NSNumber numberWithFloat:8000.00], AVSampleRateKey,
                                   [NSNumber numberWithInt:1  ], AVNumberOfChannelsKey,
                                   [NSNumber numberWithInt:16 ], AVLinearPCMBitDepthKey,
                                   [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                                   [NSNumber numberWithBool:NO], AVLinearPCMIsFloatKey,
                                   [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
                                   nil];
    
    //Now that we have our settings we are going to instanciate an instance of our recorder instance.
    //Generate a temp file for use by the recording.
    //This sample was one I found online and seems to be a good choice for making a tmp file that
    //will not overwrite an existing one.
    //I know this is a mess of collapsed things into 1 call.  I can break it out if need be.
    recordedTmpFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent: [NSString stringWithFormat: @"%.0f.%@", [NSDate timeIntervalSinceReferenceDate] * 1000.0, @"caf"]]];
    NSLog(@"Using File called: %@", recordedTmpFile);
    
    
    //Setup the recorder to use this file and record to it.
    recorder = [[AVAudioRecorder alloc] initWithURL:recordedTmpFile settings:recordSetting error:&error];
    NSLog(@"1");
    recorder.meteringEnabled = YES;
    [recorder peakPowerForChannel:0];
    //Use the recorder to start the recording.
    //Im not sure why we set the delegate to self yet.
    //Found this in antother example, but Im fuzzy on this still.
    [recorder setDelegate:self];
    //We call this to start the recording process and initialize
    //the subsstems so that when we actually say "record" it starts right away.
    [recorder prepareToRecord];
    NSLog(@"2");
    //Start the actual Recording
    [recorder record];
    NSLog(@"3");
    //There is an optional method for doing the recording for a limited time see
    //[recorder recordForDuration:(NSTimeInterval) 10]
    
    if (!level) {
        levelBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        levelBackground.backgroundColor = [UIColor colorWithWhite:0 alpha:.75];
        levelBackground.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
        levelBackground.layer.cornerRadius = 8;
        
        level = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voice_level_0.png"]];
        level.bounds = CGRectMake(0, 0, 30, 50);
        level.center = CGPointMake(50, 50);
        [levelBackground addSubview:level];
        [level release];
    }
    [[[UIApplication sharedApplication].delegate window] addSubview:levelBackground];
    
    levelTimer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self
                                                selector:@selector(levelTimerCallback:)
                                                userInfo:nil repeats:YES];
}

- (NSURL *)stopRecord {
    
    NSURL *url = [[NSURL alloc] initWithString:recorder.url.absoluteString];
    [recorder stop];
    [recorder release];
    recorder = nil;
    
    [levelBackground removeFromSuperview];
    if (levelTimer) {
        [levelTimer invalidate];
    }
    
    return [url autorelease];
}

- (void)levelTimerCallback:(NSTimer *)timer {
    [recorder updateMeters];
    NSLog(@"[%f] [%f]",[recorder averagePowerForChannel:0], [recorder peakPowerForChannel:0]);
    int power = ceil(fabsf((float)[recorder averagePowerForChannel:0]/10));
    
    switch (power) {
            
        case 1:
            level.image = [UIImage imageNamed:@"voice_level_5.png"];
            break;
        case 2:
            level.image = [UIImage imageNamed:@"voice_level_4.png"];
            break;
        case 3:
            level.image = [UIImage imageNamed:@"voice_level_3.png"];
            break;
        case 4:
            level.image = [UIImage imageNamed:@"voice_level_2.png"];
            break;
        case 5:
            level.image = [UIImage imageNamed:@"voice_level_1.png"];
            break;
        case 6:
            level.image = [UIImage imageNamed:@"voice_level_0.png"];
            
        default:
            break;
    }
}

- (void)dealloc {
    
    [recorder release];
	recorder = nil;
	recordedTmpFile = nil;
    
    [super dealloc];
}

@end
