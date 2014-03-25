//
//  MUCameraViewViewController.m
//  InteractiveMuseum
//
//  Created by Andrew Sowers on 3/23/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import "MUCameraViewViewController.h"

@interface MUCameraViewViewController ()

@end

@implementation MUCameraViewViewController
@synthesize infoLabel,infoLabel1;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    infoLabel.text = @"Or";
    infoLabel.textColor = [UIColor grayColor];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.font = [UIFont fontWithName:@"Baskerville-Italic" size:24];
    infoLabel.adjustsFontSizeToFitWidth=YES;
    
    infoLabel1.text = @"A Photo";
    infoLabel1.textColor = [UIColor grayColor];
    infoLabel1.textAlignment = NSTextAlignmentCenter;
    infoLabel1.backgroundColor = [UIColor clearColor];
    infoLabel1.font = [UIFont fontWithName:@"Baskerville-Italic" size:36];
    infoLabel1.adjustsFontSizeToFitWidth=YES;
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor redColor]];
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}

- (IBAction)takePhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (IBAction)selectPhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
    
}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}



@end
