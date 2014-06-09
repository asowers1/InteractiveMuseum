//
//  IMDetailViewController.h
//  InteractiveMuseum
//
//  Created by Ian Perry on 3/25/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMDetailViewController : UIViewController <UIAlertViewDelegate, UIActionSheetDelegate, UIGestureRecognizerDelegate> {
    int waterfallValue;
    IMMeniorManager * data;
    UIImageView *objectImageView;
    UITapGestureRecognizer *tap;
    BOOL isFullScreen;
    BOOL imageExploded;
    CGRect prevFrame;
    CGRect newFrame;

}

@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *memiorButton;

@end
