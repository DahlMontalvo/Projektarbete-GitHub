//
//  NatureResultsViewController.m
//  Projektarbete_v1_2
//
//  Created by Jonas Dahl on 2012-10-12.
//
//

#import "NatureResultsViewController.h"

@interface NatureResultsViewController ()

@end

@implementation NatureResultsViewController

@synthesize scoreLabel, timeLabel, categoryLabel, starsImageView, score, testStartedDate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    scoreLabel.text = [NSString stringWithFormat:@"%i/10", score];
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:testStartedDate]-3600;
    NSDateFormatter *objDateFormatter = [[NSDateFormatter alloc] init];
    [objDateFormatter setDateFormat:@"mm:ss.S"];
    timeLabel.text = [objDateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setScoreLabel:nil];
    [self setTimeLabel:nil];
    [self setCategoryLabel:nil];
    [self setStarsImageView:nil];
    [super viewDidUnload];
}
- (IBAction)continueButtonPressed:(id)sender {
    
    NSArray *viewControllers = [self.navigationController viewControllers];
    
    [self.navigationController popToViewController:[viewControllers objectAtIndex:1] animated:YES];
    
}
@end
