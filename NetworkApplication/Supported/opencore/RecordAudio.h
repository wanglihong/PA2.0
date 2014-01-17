//
//  RecordAudio.h
//  JuuJuu
//
//  Created by xiaoguang huang on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface RecordAudio : NSObject <AVAudioRecorderDelegate,AVAudioPlayerDelegate>
{
    //Variables setup for access in the class:
	NSURL * recordedTmpFile;
	AVAudioRecorder * recorder;
	NSError * error;
    AVAudioPlayer * avPlayer;
    id target;
}

@property (nonatomic,assign)id target;

- (NSURL *) stopRecord ;
- (void) startRecord;

-(void) play:(NSData*) data target:(id)aTarget;
-(void) stopPlay;
+(NSTimeInterval) getAudioTime:(NSData *) data;
@end
