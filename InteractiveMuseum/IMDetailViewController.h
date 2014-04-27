//
//  IMDetailViewController.h
//  InteractiveMuseum
//
//  Created by Ian Perry on 3/25/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMDetailViewController : UIViewController <UIAlertViewDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *memiorButton;
@end
