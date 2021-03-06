//
//  MUCameraViewViewController.m
//  InteractiveMuseum
//
//  Created by Andrew Sowers on 3/23/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import "MUCameraViewViewController.h"
#import "IMMeniorManager.h"
@interface MUCameraViewViewController ()

@end

@implementation MUCameraViewViewController
@synthesize infoLabel,infoLabel1,compressedImage,uncompressedImage;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:116.0/255.0 green:191.0/255.0 blue:185.0/255.0 alpha:1.0];
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    } else {
        picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:NO completion:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    IMMeniorManager *data = [[IMMeniorManager alloc] init];
    [data openDatabase];
    [data setPhotoReturn:@"yes"];
    [data setSelectionIndex:@"Object1"];
    [data closeDatabase];
}

- (IBAction)sendToServer:(UIButton *)sender
{
    NSLog(@"Sent? %i",[self uploadImage:[[NSData alloc] initWithContentsOfFile:@"file1.jpg"] filename:@"file1.jpg"]);
}

- (IBAction)takePhoto:(UIButton *)sender {
    
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (IBAction)selectPhoto:(UIButton *)sender {
    
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
    
}

- (IBAction)loadMemoir:(UIBarButtonItem *)sender
{
    DEMONavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    IMDetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"detailController"];
    navigationController.viewControllers = @[detailViewController];
    self.frostedViewController.contentViewController = navigationController;
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)pickerIn didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"FIRES");
    uncompressedImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = uncompressedImage;
    [pickerIn dismissViewControllerAnimated:NO completion:NULL];
    
    [self.navigationController popViewControllerAnimated:NO];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)pickerIn {
    
    [pickerIn dismissViewControllerAnimated:YES completion:NULL];
    [self.navigationController popViewControllerAnimated:NO];
    
}

-(void)setImageCompression
{
    [self shrinkPhotoBySize:uncompressedImage :100 :100];
    NSData *imageData = [[NSData alloc] initWithData:UIImageJPEGRepresentation((compressedImage), 0.5)];
    NSInteger imageSize = imageData.length;
    NSLog(@"SIZE OF IMAGE: %li ", (long)imageSize);

}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)shrinkPhotoBySize:(UIImage *)image :(int)x :(int)y
{
    compressedImage = [self imageWithImage:image scaledToSize:CGSizeMake(x, y)];
}


 
- (void)sendPhotoToServer {
    NSData* fileData = [[NSData alloc] initWithContentsOfFile:@"test.png"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"54.86.61.242:8001"]];
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

- (BOOL)uploadImage:(NSData *)imageData filename:(NSString *)filename{
    
    NSLog(@"uploading");
    
    NSString *urlString = @"54.86.61.242:8001";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"0xKhTmLbOuNdArY";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //Set the filename
    [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"\r\n",filename]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //append the image data
    [body appendData:[NSData dataWithData:imageData]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSLog(@"return string: %@",returnString);
    
    return ([returnString isEqualToString:@"OK"]);
}



@end
