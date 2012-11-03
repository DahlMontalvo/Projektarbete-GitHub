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

@synthesize scoreLabel, timeLabel, categoryLabel, starsImageView, score, testStartedDate, categoryId, starsLabel, highscoreLabel;

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
    
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeIntervalSince = [currentDate timeIntervalSinceDate:testStartedDate];
    float finalTime = timeIntervalSince;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSMutableArray *category = [[NSMutableArray alloc] init];
    category = [appDelegate getCategoryWithID:categoryId];
    
    categoryLabel.text = [NSString stringWithFormat:@"Completed in %@", [category objectAtIndex:0]];
    int stars;
    int starsBefore = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:[NSString stringWithFormat:@"NatureCategory%iStars",categoryId] ];
    if (score == 10) {
        if (finalTime < 20) {
            starsLabel.text = @"3 Stars!";
            stars = 3;
            if (starsBefore < 3)
                [[[Singleton sharedSingleton] sharedPrefs] setInteger:3 forKey:[NSString stringWithFormat:@"NatureCategory%iStars",categoryId]];
        }
        else if (finalTime < 40) {
            starsLabel.text = @"2 Stars!";
            stars = 2;
            if (starsBefore < 2)
                [[[Singleton sharedSingleton] sharedPrefs] setInteger:2 forKey:[NSString stringWithFormat:@"NatureCategory%iStars",categoryId]];
        }
        else if (finalTime < 60) {
            starsLabel.text = @"1 Star!";
            stars = 1;
            if (starsBefore < 1)
                [[[Singleton sharedSingleton] sharedPrefs] setInteger:1 forKey:[NSString stringWithFormat:@"NatureCategory%iStars",categoryId]];
        }
        else {
            starsLabel.text = @"No stars this time! :(";
            stars = 0;
        }
    }
    else {
        starsLabel.text = @"No stars this time! :(";
        stars = 0;
    }
    
    float previousHighscore = [[[Singleton sharedSingleton] sharedPrefs] floatForKey:[NSString stringWithFormat:@"NatureCategory%iTime",categoryId]];
    
    if ((finalTime < previousHighscore || previousHighscore == 0) && score == 10) {
        [[[Singleton sharedSingleton] sharedPrefs] setFloat:finalTime forKey:[NSString stringWithFormat:@"NatureCategory%iTime",categoryId]];
        highscoreLabel.text = @"Highscore!";
        NSLog(@"final: %f", finalTime);
    }
    else {
        NSLog(@"%f :: %f :: %i", finalTime, previousHighscore, score);
    }
    
    [[[Singleton sharedSingleton] sharedPrefs] synchronize];
    
    NSString *name;
    
    switch (stars) {
        case 0:
            name = @"NoStars.png";
            break;
        case 1:
            name = @"OneStars.png";
            break;
        case 2:
            name = @"TwoStars.png";
            break;
        case 3:
            name = @"ThreeStars.png";
            break;
        default:
            name = @"NoStars.png";
            break;
    }
    
    timeLabel.text = [NSString stringWithFormat:@"in %.2f seconds",finalTime];
    starsImageView.image = [UIImage imageNamed:name];
    
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
    [self setStarsLabel:nil];
    [self setHighscoreLabel:nil];
    [super viewDidUnload];
}
- (IBAction)continueButtonPressed:(id)sender {
    
    NSArray *viewControllers = [self.navigationController viewControllers];
    
    [self.navigationController popToViewController:[viewControllers objectAtIndex:1] animated:YES];
    
}
@end
