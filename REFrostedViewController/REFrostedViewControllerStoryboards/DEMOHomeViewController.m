//
//  DEMOHomeViewController.m
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOHomeViewController.h"

@interface DEMOHomeViewController ()

@end

@implementation DEMOHomeViewController

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
    tlabel.text=@"Interactive Museum";
    tlabel.textColor=[UIColor grayColor];
    tlabel.textAlignment=NSTextAlignmentCenter;
    tlabel.backgroundColor =[UIColor clearColor];
    tlabel.font = [UIFont fontWithName:@"Baskerville-Italic" size:24];
    tlabel.adjustsFontSizeToFitWidth=YES;
    self.navigationItem.titleView=tlabel;
    //self.title = @"Interactive Museum";
    
}

@end
