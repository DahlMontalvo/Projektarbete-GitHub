//
//  MathResultsViewController.m
//  Projektarbete_v1_2
//
//  Created by Jonas Dahl on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MathResultsViewController.h"

@implementation MathResultsViewController
@synthesize results, resultsLabel, timeLabel, infoLabel, navItem, operation, difficulty, finalTime, gamemode, gamemodeLabel, highscoreLabel, starLabel, starImage, scoreScoreLabel, starExplanationLabel;

#pragma mark - Initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

#pragma mark - View management
- (void)viewDidLoad {
    [super viewDidLoad];
    
    int stars;
    
    float timeForOneStar = (difficulty * 100)*0.6;
    float timeForTwoStars = (difficulty * 100)*0.4;
    float timeForThreeStars = ((difficulty * 100)*0.2);
    
    if (finalTime < timeForThreeStars && results == 10) {
        starLabel.text = @"3 Stars!";
        starExplanationLabel.text = @"Perfect!";
        stars = 3;
        if ([[[Singleton sharedSingleton] sharedPrefs] integerForKey:[NSString stringWithFormat:@"Stars%@%i",operation,difficulty] ] < 3)
            [[[Singleton sharedSingleton] sharedPrefs] setInteger:3 forKey:[NSString stringWithFormat:@"Stars%@%i",operation,difficulty]];
    }
    else if (finalTime < timeForTwoStars && results > 7) {
        starLabel.text = @"2 Stars!";
        starExplanationLabel.text = [NSString stringWithFormat:@"For three stars, you need all correct answers in %.02f seconds!", timeForThreeStars];
        stars = 2;
        if ([[[Singleton sharedSingleton] sharedPrefs] integerForKey:[NSString stringWithFormat:@"Stars%@%i",operation,difficulty] ] < 2)
            [[[Singleton sharedSingleton] sharedPrefs] setInteger:2 forKey:[NSString stringWithFormat:@"Stars%@%i",operation,difficulty]];
    }
    else if (finalTime < timeForOneStar && results > 5) {
        starLabel.text = @"1 Star!";
        starExplanationLabel.text = [NSString stringWithFormat:@"For two stars, you need 8 correct answers in %.02f seconds!", timeForTwoStars];

        stars = 1;
        if ([[[Singleton sharedSingleton] sharedPrefs] integerForKey:[NSString stringWithFormat:@"Stars%@%i",operation,difficulty] ] < 1)
            [[[Singleton sharedSingleton] sharedPrefs] setInteger:1 forKey:[NSString stringWithFormat:@"Stars%@%i",operation,difficulty]];
    }
    else {
        starLabel.text = @"No stars this time! :(";
        starExplanationLabel.text = [NSString stringWithFormat:@"For one star, you need 6 correct answers in %.02f seconds!", timeForOneStar];

        stars = 0;
    }
    
    [[[Singleton sharedSingleton] sharedPrefs] synchronize];
    int starsA = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:[NSString stringWithFormat:@"Stars%@1",operation]];
    int starsB = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:[NSString stringWithFormat:@"Stars%@2",operation]];
    int starsC = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:[NSString stringWithFormat:@"Stars%@3",operation]];
    int starsD = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:[NSString stringWithFormat:@"Stars%@4",operation]];
    int starsE = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:[NSString stringWithFormat:@"Stars%@5",operation]];
    int totalStars = starsA + starsB + starsC + starsD + starsE;
    
    [[[Singleton sharedSingleton] sharedPrefs] setInteger:totalStars forKey:[NSString stringWithFormat:@"TotalStars%@",operation]];
    
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
    
    starImage.image = [UIImage imageNamed:name];
    resultsLabel.text = [NSString stringWithFormat:@"%i/10", results];
    infoLabel.text = [NSString stringWithFormat:@"Completed in %@ level %i,", operation, difficulty];
    gamemodeLabel.text = gamemode;
    timeLabel.text = [NSString stringWithFormat:@"in %.2f seconds",finalTime];
    
    int previousHighscore = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:[NSString stringWithFormat:@"%@%i",operation,difficulty]];
    int scoreScore;
    
    if (stars != 0)
        scoreScore = 150-finalTime*2/stars-(3-stars)*15;
    else
        scoreScore = 0;
    if (scoreScore < 0) scoreScore = 0;
    scoreScoreLabel.text = [NSString stringWithFormat:@"%i", scoreScore];
    
    if ((scoreScore > previousHighscore) && [gamemode isEqualToString:@"Test"]) {
        [[[Singleton sharedSingleton] sharedPrefs] setInteger:scoreScore forKey:[NSString stringWithFormat:@"%@%i",operation,difficulty]];
        highscoreLabel.text = @"Highscore!";
    } else {
        highscoreLabel.text = [NSString stringWithFormat:@"Current Highscore: %i",previousHighscore];
    }
    
    int previousCompletedTests = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"CompletedTests"];

    if ([gamemode isEqualToString:@"Test"])
        [[[Singleton sharedSingleton] sharedPrefs] setInteger:previousCompletedTests+1 forKey:@"CompletedTests"];

}

- (void)viewDidUnload {
    [self setResultsLabel:nil];
    [self setStarImage:nil];
    [self setScoreScoreLabel:nil];
    [self setStarExplanationLabel:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Other
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)continueButtonPressed:(id)sender {
    NSArray *viewControllers = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[viewControllers objectAtIndex:1] animated:YES];
}

@end