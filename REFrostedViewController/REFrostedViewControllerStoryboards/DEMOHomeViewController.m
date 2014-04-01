//
//  DEMOHomeViewController.m
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOHomeViewController.h"
#import "MUCameraViewViewController.h"
@interface DEMOHomeViewController ()


@end

@implementation DEMOHomeViewController
@synthesize cameraButton;
- (IBAction)showMenu
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}

-(void)viewDidLoad{
    UILabel* tlabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0, 300, 40)];
    tlabel.text=@"VisitTheMuseum";
    tlabel.textColor=[UIColor colorWithRed:116.0/255.0 green:191.0/255.0 blue:185.0/255.0 alpha:1.0];
    tlabel.textAlignment=NSTextAlignmentCenter;
    //tlabel.backgroundColor =[UIColor clearColor];
    tlabel.font = [UIFont fontWithName:@"Baskerville-BoldItalic" size:28];
    tlabel.adjustsFontSizeToFitWidth=YES;
    self.navigationItem.titleView=tlabel;
    //self.title = @"Interactive Museum";
}


@end
