//
//  IMAudioPlayerView.m
//  InteractiveMuseum
//
//  Created by Ian Perry on 4/1/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import "IMAudioPlayerView.h"
#import <AVFoundation/AVFoundation.h>

@interface IMAudioPlayerView()
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) UILabel *clipLengthLabel;
@end

@implementation IMAudioPlayerView

- (id)initWithFrame:(CGRect)frame audioFile:(NSString *)audioFileName andImageFile:(NSString *)imageFileName
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor lightGrayColor];
        
        // label for displaying audio file name
        
        // TODO: correct format for displaying audio file name 
//        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/4, 0, 80, 30)];
        
//        NSArray *componentsOfFileName = [audioFileName componentsSeparatedByString:@"."];
//        titleLabel.text = [NSString stringWithFormat:@"%@", [componentsOfFileName objectAtIndex:1]];
//        [titleLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:10.0]];
//        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        titleLabel.numberOfLines = 3;
//        [self addSubview:titleLabel];
        
        // image view for displaying the speaker image
        UIImageView *audioImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height - 21, 25, 21)];
        audioImage.image = [UIImage imageNamed:@"Audio"];
        [self addSubview:audioImage];
     
        // label for displaying length of clip
        self.clipLengthLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - 30, frame.size.height - 21, 30, 21)];
        [self.clipLengthLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:12.0]];
        [self addSubview:self.clipLengthLabel];
        
        [self setUpAudioWithFileName:audioFileName];
        
        // add tap gesture for playing audio
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playAudio:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setUpAudioWithFileName:(NSString *)audioFileName
{
    NSString *audioFilePath = [[NSBundle mainBundle] pathForResource:audioFileName ofType:@"mp3"];
    NSData *audioData = [[NSFileManager defaultManager] contentsAtPath:audioFilePath];
    NSError *error = nil;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:audioData error:&error];
    [self.audioPlayer prepareToPlay];
    NSTimeInterval clipDuration = self.audioPlayer.duration;
    self.clipLengthLabel.text = [self timeIntervalToMinutesAndSeconds:clipDuration];
}

- (void)playAudio:(UITapGestureRecognizer *)recognizer
{
    if (self.audioPlayer.playing)
    {
        [self.audioPlayer pause];
    }
    else
    {
        [self.audioPlayer play];
    }
}

- (NSString *)timeIntervalToMinutesAndSeconds:(NSTimeInterval)interval
{
    NSInteger intInterval = (NSInteger)interval;
    NSInteger minutes = (intInterval/60) % 60;
    NSInteger seconds = intInterval % 60;
    
    return [NSString stringWithFormat:@"%ld:%ld", (long)minutes, (long)seconds];
}

@end
