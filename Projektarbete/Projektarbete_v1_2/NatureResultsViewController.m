//
//  NatureResultsViewController.m
//  Simple Science
//
//  Copyright (c) 2013 Jonas Dahl & Philip Montalvo. All rights reserved.
//

#import "NatureResultsViewController.h"
#import "Flurry.h"
#import "GameKitHelper.h"

@interface NatureResultsViewController ()

@end

@implementation NatureResultsViewController

@synthesize scoreLabel, timeLabel, categoryLabel, starsImageView, score, testStartedDate, categoryId, starsLabel, highscoreLabel, subject, description, scoreScoreLabel;

#pragma mark - Initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

#pragma mark - View management
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
        category = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"Mixed %@", subject], subject, @"-1", nil];
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
    
    if (finalTime < 60 && score == 10) {
        starsLabel.text = @"3 Stars!";
        description.text = @"Perfect!";
        stars = 3;
        if (starsBefore < 3)
            [[[Singleton sharedSingleton] sharedPrefs] setInteger:3 forKey:key];
    }
    else if (finalTime < 90 && score > 7) {
        starsLabel.text = @"2 Stars!";
        description.text = @"For three stars, you need all correct answers in 60 seconds.";
        stars = 2;
        if (starsBefore < 2)
            [[[Singleton sharedSingleton] sharedPrefs] setInteger:2 forKey:key];
    }
    else if (finalTime < 140 && score > 5) {
        starsLabel.text = @"1 Star!";
        description.text = @"For two stars, you need 8 correct answers in 90 seconds.";
        stars = 1;
        if (starsBefore < 1)
            [[[Singleton sharedSingleton] sharedPrefs] setInteger:1 forKey:key];
    }
    else {
        starsLabel.text = @"No stars this time.";
        description.text = @"For one star, you need 6 correct answers in 140 seconds.";
        stars = 0;
    }
    
    int scoreScore;
    scoreScore = (score / sqrt(finalTime)*447.2135956);
    //150-finalTime/stars-(3-stars)*15;
    
    if (scoreScore < 0) scoreScore = 0;
    
    //GAME CENTER

    NSString *smallLetterSubject;
    if ([subject isEqualToString:@"Biology"]) {
        smallLetterSubject = @"biology";
    }
    if ([subject isEqualToString:@"Chemistry"]) {
        smallLetterSubject = @"chemistry";
    }
    if ([subject isEqualToString:@"Physics"]) {
        smallLetterSubject = @"physics";
    }
    
    [[GameKitHelper sharedGameKitHelper] submitScore:(int64_t)scoreScore category:[NSString stringWithFormat:@"mixed_%@_highscores",smallLetterSubject]];
    
    int previousHighscore = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:timeKey];
    
    if (scoreScore > previousHighscore) {
        [[[Singleton sharedSingleton] sharedPrefs] setInteger:scoreScore forKey:timeKey];
        highscoreLabel.text = @"Highscore!";
    } else {
        //Jadu dahl, den här lilla detaljen hade du minsann glömt, den sa att den alltid fick highscore pga interfacebuilder!
        highscoreLabel.text = @"";
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
    
    
    
    NSDictionary *eventParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     subject, @"Subject",
     [category objectAtIndex:0], @"CategoryName",
     [category objectAtIndex:1], @"CategoryID",
     nil];
    
    [Flurry logEvent:@"Test_completed" withParameters:eventParams];
    
    
    
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
    
    int totalCorrect = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"TotalCorrect"];
    [[[Singleton sharedSingleton] sharedPrefs] setInteger:totalCorrect+score forKey:@"TotalCorrect"];
    
    int totalHighscore = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"TotalHighscore"];
    [[[Singleton sharedSingleton] sharedPrefs] setInteger:totalHighscore+scoreScore forKey:@"TotalHighscore"];
    
    //End of global stats
    
    [[GameKitHelper sharedGameKitHelper] submitScore:(int64_t)totalHighscore + scoreScore category:@"totalScore"];
    
    [GameKitHelper getScoreInCategory];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setScoreLabel:nil];
    [self setTimeLabel:nil];
    [self setCategoryLabel:nil];
    [self setStarsImageView:nil];
    [self setStarsLabel:nil];
    [self setHighscoreLabel:nil];
    [self setDescription:nil];
    [super viewDidUnload];
}

#pragma mark - Others
- (IBAction)continueButtonPressed:(id)sender {
    NSArray *viewControllers = [self.navigationController viewControllers];
    if ([viewControllers count] >= 2)
        [self.navigationController popToViewController:[viewControllers objectAtIndex:1] animated:YES];
    else
        [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
