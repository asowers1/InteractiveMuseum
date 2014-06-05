//
//  IMDialViewController.m
//  EsVerta LLC
//
//  Created by Andrew Sowers on 6/4/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import "IMDialViewController.h"
#import "DEMOMenuViewController.h"
#import "DEMOHomeViewController.h"
#import "DEMOSecondViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "DEMONavigationController.h"
#import "IMDetailViewController.h"
#import "IMMeniorManager.h"
@interface IMDialViewController ()
@property (strong, nonatomic) IBOutlet UITextView *dialText;

@end

@implementation IMDialViewController
@synthesize dialText;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)GO:(id)sender {
    IMMeniorManager *data = [[IMMeniorManager alloc] init];
    [data openDatabase];
    
    // todo see if object exitsts and fire notification if not
    NSString * index = dialText.text;
    NSString * object = [NSString stringWithFormat:@"Object%@",index];
    
    if ([data checkForObject:index]){
        [data setPhotoReturn:@"yes"];
        [data setSelectionIndex:object];
        NSLog(@"SELECT INDEX: %@",[data getSelectionIndex]);
        [data closeDatabase];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"Object not found, please try again." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
        [dialText becomeFirstResponder];
        [data closeDatabase];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dialText.text = @"0000";
    dialText.textColor = [UIColor grayColor];
    dialText.delegate = self;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:116.0/255.0 green:191.0/255.0 blue:185.0/255.0 alpha:1.0];
    [dialText becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    dialText.text = @"";
    dialText.textColor = [UIColor blackColor];
    return 1;
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (dialText.text.length == 0) {
        dialText.textColor = [UIColor grayColor];
        dialText.text = @"0000";
        [dialText resignFirstResponder];
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
