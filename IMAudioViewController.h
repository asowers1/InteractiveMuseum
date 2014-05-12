//
//  IMAudioViewController.h
//  InteractiveMuseum
//
//  Created by Andrew Sowers on 5/10/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface IMAudioViewController : UIViewController<AVAudioRecorderDelegate, AVAudioPlayerDelegate>{
    NSInteger count;
    NSTimer *countTicker;
}

@property (weak, nonatomic) IBOutlet UIButton *recordPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

- (IBAction)recordPauseTapped:(id)sender;
- (IBAction)stopTapped:(id)sender;
- (IBAction)playTapped:(id)sender;


@end
