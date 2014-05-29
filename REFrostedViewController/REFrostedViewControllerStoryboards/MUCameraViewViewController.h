//
//  MUCameraViewViewController.h
//  InteractiveMuseum
//
//  Created by Andrew Sowers on 3/23/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEMOMenuViewController.h"
#import "DEMOHomeViewController.h"
#import "DEMOSecondViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "DEMONavigationController.h"
#import "IMDetailViewController.h"
@interface MUCameraViewViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)takePhoto:  (UIButton *)sender;
- (IBAction)selectPhoto:(UIButton *)sender;
- (IBAction)sendToServer:(UIButton *)sender;
- (IBAction)loadMemoir:(UIBarButtonItem *)sender;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel1;
@property (weak, nonatomic) UIImage *uncompressedImage;
@property (weak, nonatomic) UIImage *compressedImage;


@end
