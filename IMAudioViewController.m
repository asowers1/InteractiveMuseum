//
//  IMAudioViewController.m
//  InteractiveMuseum
//
//  Created by Andrew Sowers on 5/10/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import "IMAudioViewController.h"
#import "FFCircularProgressView.h"
#import "IMMeniorManager.h"


@interface IMAudioViewController ()
{
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
}
@property (strong) FFCircularProgressView *circularPV;

@end

@implementation IMAudioViewController
@synthesize stopButton, playButton, recordPauseButton, timeLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Disable Stop/Play button when application launches
    [stopButton setEnabled:NO];
    [playButton setEnabled:NO];
    
    // Set the audio file
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"MyAudioMemo.m4a",
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:nil];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:116.0/255.0 green:191.0/255.0 blue:185.0/255.0 alpha:1.0];
    count=0;
    
    self.circularPV = [[FFCircularProgressView alloc] initWithFrame:CGRectMake(40, 40, 160, 160)];
    _circularPV.center = self.view.center;
    


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)counter
{
    count++;
    NSString *countString = [NSString stringWithFormat:@"%ld/30",(long)count];
    timeLabel.text = countString;
    if (count>=30){
        [self resetCounter];
    }
}

- (void)resetCounter
{
    count=0;
    [countTicker invalidate];
    countTicker = nil;
    //[self recordPauseLogic];
}

-(void)pauseCounter
{
    [countTicker invalidate];
    countTicker = nil;
}

- (IBAction)recordPauseTapped:(id)sender {
    [self recordPauseLogic];
}

- (void)recordPauseLogic
{
    // Stop the audio player before recording
    if (player.playing) {
        [player stop];
        [self pauseCounter];
    }
    
    if (!recorder.recording) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        countTicker = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                       target:self
                                                     selector:@selector(counter)
                                                     userInfo:nil
                                                      repeats:1];
//        [self.view addSubview:_circularPV];
        
//        [_circularPV startSpinProgressBackgroundLayer];
//        __block BOOL cancelled = NO;
//        double delayInSeconds = 2.5;
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//        dispatch_after(popTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
//                for (float i=0; i<1.1; i+=0.01F) {
//                    while (!cancelled) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [_circularPV setProgress:i];
//                    });
//                    usleep(10000);
//                        
//                    }
//                }
//            
//            double delayInSeconds = 2.0;
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                [_circularPV setProgress:0];
//            });
//            
//        });
//        cancelledPtr = &cancelled;
//        delayInSeconds = 2;
//        popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//            [_circularPV stopSpinProgressBackgroundLayer];
//        });
        // Start recording
        [recorder record];
        [recordPauseButton setTitle:@"Stop" forState:UIControlStateNormal];
        
    } else {
        
        // Pause recording
        [self stopLogic];
        [recorder stop];
        [recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
    }
    
    [stopButton setEnabled:YES];
    [playButton setEnabled:NO];
}

- (IBAction)stopTapped:(id)sender {
    [self stopLogic];
}

- (void)stopLogic
{
    if (cancelledPtr)
    {

    }
    
}

- (IBAction)playTapped:(id)sender {
    if (!recorder.recording){
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
        [player setDelegate:self];
        [player play];
    }
}

#pragma mark - AVAudioRecorderDelegate

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    
    [recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
    [stopButton setEnabled:NO];
    [playButton setEnabled:YES];
    [self finishedPlayerAlert];
    [self resetCounter];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
    [countTicker invalidate];
    countTicker = nil;
    
}

#pragma mark - AVAudioPlayerDelegate

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [recorder stop];
}


#pragma mark - User audio input methods

-(void)finishedPlayerAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Vioce note complete"
                                                    message: @"Would like like to save it?"
                                                   delegate: self
                                          cancelButtonTitle:@"Redo?"
                                          otherButtonTitles:@"Fished",
                          nil];
    [alert show];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //u need to change 0 to other value(,1,2,3) if u have more buttons.then u can check which button was pressed.
    
    if (buttonIndex == 0) {
        
        [self recordPauseLogic];
        
        
    }else if(buttonIndex == 1){
        // save file with memoir object reference
        IMMeniorManager *data = [[IMMeniorManager alloc] init];
        [data openDatabase];
        NSString *currentObject = [data getSelectionIndex];
        //save audio data with reference to currentObject
        //TO DO
    }
    
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
