//
//  IMDetailViewController.m
//  InteractiveMuseum
//
//  Created by Ian Perry on 3/25/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import "IMDetailViewController.h"
#import "REFrostedViewController.h"


@interface IMDetailViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) IBOutlet UILabel *collectionLabel;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;

@end

@implementation IMDetailViewController

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
    // Do any additional setup after loading the view.
}

- (IBAction)showMenu:(id)sender {
    [self.frostedViewController presentMenuViewController];
}


@end
