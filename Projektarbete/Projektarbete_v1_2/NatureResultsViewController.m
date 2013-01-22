//
//  NatureResultsViewController.m
//  Projektarbete_v1_2
//
//  Created by Jonas Dahl on 2012-10-12.
//
//

#import "NatureResultsViewController.h"
#import "Flurry.h"

@interface NatureResultsViewController ()

@end

@implementation NatureResultsViewController

@synthesize scoreLabel, timeLabel, categoryLabel, starsImageView, score, testStartedDate, categoryId, starsLabel, highscoreLabel, subject, description, scoreScoreLabel;

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
    NSMutableArray *category;
    if (categoryId > 0) {
        category = [[NSMutableArray alloc] init];
        category = [appDelegate getCategoryWithID:categoryId];
    }
    else {
        category = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"Mixed %@", subject], nil];
    }
    
    categoryLabel.text = [NSString stringWithFormat:@"Completed in %@", [category objectAtIndex:0]];
    int stars;
    int starsBefore;
    NSString *key;
    NSString *timeKey;
    if (categoryId > 0) {
        key = [NSString stringWithFormat:@"NatureCategory%iStars",categoryId];
        timeKey = [NSString stringWithFormat:@"NatureCategory%iTime",categoryId];
    }
    else {
        key = [NSString stringWithFormat:@"NatureCategory%@Mixed", subject];
        timeKey = [NSString stringWithFormat:@"NatureCategory%@MixedTime",subject];
    }
    
    starsBefore = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:key];
    
    if (finalTime < 50 && score == 10) {
        starsLabel.text = @"3 Stars!";
        description.text = @"Perfect!";
        stars = 3;
        if (starsBefore < 3)
            [[[Singleton sharedSingleton] sharedPrefs] setInteger:3 forKey:key];
    }
    else if (finalTime < 60 && score > 7) {
        starsLabel.text = @"2 Stars!";
        description.text = @"For three stars, you need all correct answers in 50 seconds.";
        stars = 2;
        if (starsBefore < 2)
            [[[Singleton sharedSingleton] sharedPrefs] setInteger:2 forKey:key];
    }
    else if (finalTime < 100 && score > 5) {
        starsLabel.text = @"1 Star!";
        description.text = @"For two stars, you need 8 correct answers in 60 seconds.";
        stars = 1;
        if (starsBefore < 1)
            [[[Singleton sharedSingleton] sharedPrefs] setInteger:1 forKey:key];
    }
    else {
        starsLabel.text = @"No stars this time.";
        description.text = @"For one star, you need 6 correct answers in 100 seconds.";
        stars = 0;
    }
    
    int scoreScore;
    if (stars != 0)
        scoreScore = (score / sqrt(finalTime)*447.2135956);
        //150-finalTime/stars-(3-stars)*15;
    else
        scoreScore = 0;
    if (scoreScore < 0) scoreScore = 0;
    int previousHighscore = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:timeKey];
    
    if (scoreScore > previousHighscore) {
        [[[Singleton sharedSingleton] sharedPrefs] setInteger:scoreScore forKey:timeKey];
        highscoreLabel.text = @"Highscore!";
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
    scoreScoreLabel.text = [NSString stringWithFormat:@"%i", scoreScore];
    starsImageView.image = [UIImage imageNamed:name];
    
    [Flurry logEvent:[NSString stringWithFormat:@"Test completed in nature category %@", [category objectAtIndex:0]]];
    
//Global Stats
    int previousCompletedTests = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"CompletedTests"];
    [[[Singleton sharedSingleton] sharedPrefs] setInteger:previousCompletedTests+1 forKey:@"CompletedTests"];
    
    int tenOutOfTens = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"TenOutOfTens"];
    if (score == 10) {
        [[[Singleton sharedSingleton] sharedPrefs] setInteger:tenOutOfTens+1 forKey:@"TenOutOfTens"];
    }
    
    
    int bestHighscore  = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"BestHighscore"];
    if (scoreScore > bestHighscore) {
        [[[Singleton sharedSingleton] sharedPrefs] setInteger:scoreScore forKey:@"BestHighscore"];
        
    }
    
    int timesPlayedSubject = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:[NSString stringWithFormat:@"TimesPlayed%@",subject]];
    [[[Singleton sharedSingleton] sharedPrefs] setInteger:timesPlayedSubject+1 forKey:[NSString stringWithFormat:@"TimesPlayed%@",subject]];


    
//End of global stats

    
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
    [self setDescription:nil];
    [self setScore:nil];
    [super viewDidUnload];
}
- (IBAction)continueButtonPressed:(id)sender {
    
    NSArray *viewControllers = [self.navigationController viewControllers];
    
    [self.navigationController popToViewController:[viewControllers objectAtIndex:1] animated:YES];
    
}
@end
