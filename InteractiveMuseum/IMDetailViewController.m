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
#import "IMAudioPlayerView.h"
#import "IMMeniorManager.h"

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
    
    // target - what object is going to handle
    // the gesture when it gets recognised
    // the argument for tap: is the gesture that caused this message to be sent
    UITapGestureRecognizer *tapOnce =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapOnce:)];
    UITapGestureRecognizer *tapTwice =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapTwice:)];
    
    tapOnce.numberOfTapsRequired = 1;
    tapTwice.numberOfTapsRequired = 2;
    
    //stops tapOnce from overriding tapTwice
    [tapOnce requireGestureRecognizerToFail:tapTwice];
    
    // then need to add the gesture recogniser to a view
    // - this will be the view that recognises the gesture
    [self.imageView addGestureRecognizer:tapOnce];
    [self.imageView addGestureRecognizer:tapTwice];
    prevFrame = CGRectMake(20, 139, 170, 212);
    newFrame = CGRectMake(0, 64, 320, 536);
    NSLog(@"load detail");
    
}

- (void)tapOnce:(UIGestureRecognizer *)gesture
{
    
    NSLog(@"tapOnce");
    
}
- (void)tapTwice:(UIGestureRecognizer *)gesture
{

    if (CGRectEqualToRect(self.imageView.frame, prevFrame)) {
    //[self.view bringSubviewToFront:self.imageView];
        [UIView animateWithDuration:0.2
                     animations:^{
                         self.imageView.frame = newFrame;
                     }];

    NSLog(@"tapTwice");
    }else if(CGRectEqualToRect(self.imageView.frame, newFrame)){
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.imageView.frame = prevFrame;
                         }];
    }

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    data = nil;
    data = [[IMMeniorManager alloc] init];
    //[data setupDatabaseSession];
    [self loadArtPeiceFromSQLite];
    self.artPiece = [[IMArtPiece alloc] init];
    [self loadArtPeiceFromSQLite];
    [self setUpView];
    [self.view bringSubviewToFront:self.imageView];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    
}

-(void)loadArtPeiceFromSQLite
{
    
    // get current view from global data
    // set current waterfall value
    // load from hmtl
    IMMeniorManager * database = [[IMMeniorManager alloc] init];
    [database openDatabase];
    NSString * waterfallIndex = [database getSelectionIndex];
    [database closeDatabase];
    [self loadHTMLIntoView:waterfallIndex];
    
}

- (IBAction)showMenu:(id)sender {
    [self.frostedViewController presentMenuViewController];
}

- (void)loadHTMLIntoView:(NSString *)toLoad
{
    NSString *path = [[NSBundle mainBundle] pathForResource:toLoad ofType:@"html"];
    NSData * HTMLdata = [[NSFileManager defaultManager] contentsAtPath:path];
    
    TFHpple *parser = [TFHpple hppleWithHTMLData:HTMLdata];
    NSString *picImageQueryString = @"//img[@class='chosen-pic']";
    NSString *picInfoQueryString = @"//p[@class='picinfo']";
    NSString *picDescriptionQueryString = @"//div[@class='picdesc']/p";
    NSString *picWikipediaDescriptionQueryString = @"//div[@class='wikipedia']/p";
    NSString *audioFileNameQueryString = @"//div[@class='clearfix audio-ctrl']";
    
    // get the image file name from the HTML file
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
    
    // get the descriptions, separated by paragraph tag
    NSArray *picDescription = [parser searchWithXPathQuery:picDescriptionQueryString];
    NSMutableArray *pieceDescriptions = [[NSMutableArray alloc] init];
    for (TFHppleElement *element in picDescription) {
        NSString *description = [[element firstChild] content];
        [pieceDescriptions addObject:description];
    }
    self.artPiece.descriptions = [[NSMutableArray alloc] initWithArray:pieceDescriptions];
    
    // get the Wikipedia descriptions, separated by paragraph tag
    NSArray *picWikipediaDescription = [parser searchWithXPathQuery:picWikipediaDescriptionQueryString];
    NSMutableArray *wikipediaDescriptions = [[NSMutableArray alloc] init];
    for (TFHppleElement *element in picWikipediaDescription) {
        NSString *description = [[element firstChild] content];
        [wikipediaDescriptions addObject:description];
    }
    self.artPiece.wikipediaDescriptions = [[NSMutableArray alloc] initWithArray:wikipediaDescriptions];
    
    // get the audio file name from the HTML file
    NSArray *audioFileName = [parser searchWithXPathQuery:audioFileNameQueryString];
    for (TFHppleElement *element in audioFileName) {
        NSString *fileName = [element objectForKey:@"data-audiosrc"];
        self.artPiece.audioFileName = fileName;
    }
}

- (void)setUpView
{
    self.imageView.image = [UIImage imageNamed:self.artPiece.imageName];
    self.titleLabel.text = self.artPiece.title;
    self.authorLabel.text = self.artPiece.author;
    self.collectionLabel.text = self.artPiece.collection;
    if([self.artPiece.descriptions count]>0)
        self.descriptionTextView.text = [self.artPiece.descriptions objectAtIndex:0];
    
    if([self.artPiece.wikipediaDescriptions count]>0)
        self.wikipediaDescriptionTextView.text = [self.artPiece.wikipediaDescriptions objectAtIndex:0];
    
    IMAudioPlayerView *audioPlayerView = [[IMAudioPlayerView alloc] initWithFrame:CGRectMake(225, 139, 75, 55) audioFile:self.artPiece.audioFileName andImageFile:self.artPiece.imageName];
    [self.view addSubview:audioPlayerView];
}

- (IBAction)share:(id)sender {
    
    UIImage *image = [UIImage imageNamed:self.artPiece.imageName];
    NSString *shareString = [self.artPiece.descriptions objectAtIndex:0];
    NSArray *activityItems = [NSArray arrayWithObjects:shareString,image, nil];
    UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    [self presentViewController:activityView animated:YES completion:nil];
}

@end
