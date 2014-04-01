//
//  IMDetailViewController.m
//  InteractiveMuseum
//
//  Created by Ian Perry on 3/25/14.
//  Copyright (c) 2014 Andrew Sowers. All rights reserved.
//

#import "IMDetailViewController.h"
#import "REFrostedViewController.h"
#import "TFHpple.h"
#import "IMArtPiece.h"


@interface IMDetailViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) IBOutlet UILabel *collectionLabel;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet UITextView *wikipediaDescriptionTextView;
@property (strong, nonatomic) IMArtPiece *artPiece;
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
    
    UILabel* tlabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0, 300, 40)];
    tlabel.text=@"VisitTheMuseum";
    tlabel.textColor=[UIColor colorWithRed:116.0/255.0 green:191.0/255.0 blue:185.0/255.0 alpha:1.0];
    tlabel.textAlignment=NSTextAlignmentCenter;
    //tlabel.backgroundColor =[UIColor clearColor];
    tlabel.font = [UIFont fontWithName:@"Baskerville-Italic" size:28];
    tlabel.adjustsFontSizeToFitWidth=YES;
    self.navigationItem.titleView=tlabel;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.artPiece = [[IMArtPiece alloc] init];
    [self loadHTMLIntoView];
    [self setUpView];
}

- (IBAction)showMenu:(id)sender {
    [self.frostedViewController presentMenuViewController];
}

- (void)loadHTMLIntoView
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Object1" ofType:@"html"];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
    
    TFHpple *parser = [TFHpple hppleWithHTMLData:data];
    NSString *picImageQueryString = @"//img[@class='chosen-pic']";
    NSString *picInfoQueryString = @"//p[@class='picinfo']";
    NSString *picDescriptionQueryString = @"//div[@class='picdesc']/p";
    NSString *picWikipediaDescriptionQueryString = @"//div[@class='wikipedia']/p";
    
    // get the image name from the HTML file
    NSArray *imageName = [parser searchWithXPathQuery:picImageQueryString];
    for (TFHppleElement *element in imageName) {
        NSString *imageFileName = [element objectForKey:@"src"];
        self.artPiece.imageName = imageFileName;
    }
    
    // get the title, author, and collection from the HTML file
    NSArray *picInfo = [parser searchWithXPathQuery:picInfoQueryString];
    for (TFHppleElement *element in picInfo) {
        NSString *idAttribute = [element objectForKey:@"id"];
        if ([idAttribute isEqualToString:@"title"])
        {
            self.artPiece.title = [[element firstChild] content];
        }
        else if ([idAttribute isEqualToString:@"author"])
        {
            self.artPiece.author = [[element firstChild] content];
        }
        else if ([idAttribute isEqualToString:@"collection"])
        {
            self.artPiece.collection = [[element firstChild] content];
        }
    }
    
    NSArray *picDescription = [parser searchWithXPathQuery:picDescriptionQueryString];
    NSMutableArray *pieceDescriptions = [[NSMutableArray alloc] init];
    for (TFHppleElement *element in picDescription) {
        NSString *description = [[element firstChild] content];
        [pieceDescriptions addObject:description];
    }
    self.artPiece.descriptions = [[NSMutableArray alloc] initWithArray:pieceDescriptions];
    
    NSArray *picWikipediaDescription = [parser searchWithXPathQuery:picWikipediaDescriptionQueryString];
    NSMutableArray *wikipediaDescriptions = [[NSMutableArray alloc] init];
    for (TFHppleElement *element in picWikipediaDescription) {
        NSString *description = [[element firstChild] content];
        [wikipediaDescriptions addObject:description];
    }
    self.artPiece.wikipediaDescriptions = [[NSMutableArray alloc] initWithArray:wikipediaDescriptions];
}

- (void)setUpView
{
    self.imageView.image = [UIImage imageNamed:self.artPiece.imageName];
    self.titleLabel.text = self.artPiece.title;
    self.authorLabel.text = self.artPiece.author;
    self.collectionLabel.text = self.artPiece.collection;
    self.descriptionTextView.text = [self.artPiece.descriptions objectAtIndex:0];
    self.wikipediaDescriptionTextView.text = [self.artPiece.wikipediaDescriptions objectAtIndex:0];
}


@end
