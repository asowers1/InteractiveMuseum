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
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:116.0/255.0 green:191.0/255.0 blue:185.0/255.0 alpha:1.0];
    
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
- (IBAction)sendButton:(id)sender {
    [self sendPhotoToServer];
}

- (void)sendPhotoToServer {
    NSData* fileData = [[NSData alloc] initWithContentsOfFile:@"photo.jpg"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://54.84.76.140:8000"]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"0xKhTmLbOuNdArY"; // This is important! //NSURLConnection is very sensitive to format.
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"param1\"; filename=\"thefilename\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:fileData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"param2\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"paramstringvalue1" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"param3\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"paramstringvalue2" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // now lets make the connection to the web
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString* newStr = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"DATA: %@",newStr);
}



@end
