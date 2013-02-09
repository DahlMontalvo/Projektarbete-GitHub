//
//  MathResultsViewController.m
//  Simple Science
//
//  Copyright (c) 2013 Jonas Dahl & Philip Montalvo. All rights reserved.
//

#import "MathResultsViewController.h"
#import "Flurry.h"
#import "GameKitHelper.h"

@implementation MathResultsViewController
@synthesize results, resultsLabel, timeLabel, infoLabel, navItem, operation, difficulty, finalTime, gamemode, gamemodeLabel, highscoreLabel, starLabel, starImage, scoreScoreLabel, starExplanationLabel;

#pragma mark - Initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

#pragma mark - View management
- (void)viewDidLoad {
    [super viewDidLoad];
    
    int stars;
    
    int multi = 0;
    if ([operation isEqualToString:@"Percent"] || [operation isEqualToString:@"Equations"] || [operation isEqualToString:@"Fraction"]) {
        multi=10;
    }
    
    float timeForOneStar = (difficulty * 100)*0.6+multi;
    float timeForTwoStars = (difficulty * 100)*0.4+multi;
    float timeForThreeStars = ((difficulty * 100)*0.2+multi);
    
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
    
    scoreScore = (results / sqrt(finalTime)*447.2135956);
    if ([operation isEqualToString:@"Percent"] ||
        [operation isEqualToString:@"Fraction"] ||
        [operation isEqualToString:@"Equations"]) {
        
        int minus = 15-finalTime;
        if (minus < 0) minus = 0;
        minus*=45;
        scoreScore-=minus;
    }
    
    if (scoreScore < 0) scoreScore = 0;
    
    scoreScoreLabel.text = [NSString stringWithFormat:@"%i", scoreScore];
    
    if ((scoreScore > previousHighscore) && [gamemode isEqualToString:@"Test"]) {
        [[[Singleton sharedSingleton] sharedPrefs] setInteger:scoreScore forKey:[NSString stringWithFormat:@"%@%i",operation,difficulty]];
        highscoreLabel.text = @"Highscore!";
    } else {
        highscoreLabel.text = [NSString stringWithFormat:@"Current Highscore: %i",previousHighscore];
    }
    
    //Global Stats
    
    if (difficulty > 2) {
        
        int previousCompletedTests = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"CompletedTests"];
        if ([gamemode isEqualToString:@"Test"])
            [[[Singleton sharedSingleton] sharedPrefs] setInteger:previousCompletedTests+1 forKey:@"CompletedTests"];
        
        int tenOutOfTens = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"TenOutOfTens"];
        if (results == 10) {
            [[[Singleton sharedSingleton] sharedPrefs] setInteger:tenOutOfTens+1 forKey:@"TenOutOfTens"];
            
            int bestHighscore  = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"TenOutOfTens"];
            if (scoreScore > bestHighscore) {
                [[[Singleton sharedSingleton] sharedPrefs] setInteger:scoreScore forKey:@"BestHighscore"];
                
            }
            
            int timesPlayedMa = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"TimesPlayedMa"];
            [[[Singleton sharedSingleton] sharedPrefs] setInteger:timesPlayedMa+1 forKey:@"TimesPlayedMa"];
            
        }
        
        int totalCorrect = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"TotalCorrect"];
        [[[Singleton sharedSingleton] sharedPrefs] setInteger:totalCorrect+results forKey:@"TotalCorrect"];
        
        int totalHighscore = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"TotalHighscore"];
        [[[Singleton sharedSingleton] sharedPrefs] setInteger:totalHighscore+scoreScore forKey:@"TotalHighscore"];
        
        //End of global stats
        
    }
    
    if (difficulty  > 2 && [gamemode isEqualToString:@"Test"]) {
           [GameKitHelper submitAndAddScore:scoreScore];
    }
    
 
    
    
    
    NSDictionary *eventParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     @"Math", @"Subject",
     gamemode, @"GameMode",
     operation, @"CategoryName",
     [NSString stringWithFormat:@"%i", difficulty], @"Difficulty",
     nil];
    
    [Flurry logEvent:@"Test_completed" withParameters:eventParams];
    
    //Achievements
    
    if (difficulty == 5 && results == 10 && [gamemode isEqualToString:@"Test"]) {
        //Math Magician
        [[GameKitHelper sharedGameKitHelper] reportAchievementIdentifier:@"math_magician" percentComplete:100.0];
    }
    
    int total = 0;
    int mathStars = 0;
    //Matten
    NSMutableArray *operations = [[NSMutableArray alloc] initWithObjects:@"Addition",
                                  @"Subtraction",
                                  @"Multiplication",
                                  @"Division",
                                  @"Percent",
                                  @"Fraction",
                                  @"Equations",
                                  nil];
    for (int a = 0; a < [operations count]; a++) {
        for (int i = 1; i < 6; i++) {
            NSString *key = [NSString stringWithFormat:@"Stars%@%i", [operations objectAtIndex:a], i];
            int thisStars = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:key];
            total+=3;
            mathStars+=thisStars;
        }
    }
    int totalMathStars = total;
    
    //Master of Maths
    [[GameKitHelper sharedGameKitHelper] reportAchievementIdentifier:@"master_of_mathematics" percentComplete:((float)mathStars/(float)total)*100.0+0.5];
    
    //Samla underkategorierna i sina arrayer beroende på överkategori
    NSMutableArray *biologyCategories = [[NSMutableArray alloc] init];
    NSMutableArray *chemistryCategories = [[NSMutableArray alloc] init];
    NSMutableArray *physicsCategories = [[NSMutableArray alloc] init];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    for (int i = 0; i < [appDelegate.categories count]; i++) {
        NSString *name = [[appDelegate.categories objectAtIndex:i] objectAtIndex:0];
        NSString *parent = [[appDelegate.categories objectAtIndex:i] objectAtIndex:1];
        int ID = [[[appDelegate.categories objectAtIndex:i] objectAtIndex:2] intValue];
        NSMutableArray *temp = [[NSMutableArray alloc] initWithObjects:name, parent, [NSNumber numberWithInt:ID], nil];
        NSString *sub = [[appDelegate.categories objectAtIndex:i] objectAtIndex:1];
        
        if ([sub isEqualToString:@"Physics"])
            [physicsCategories addObject:temp];
        else if ([sub isEqualToString:@"Chemistry"])
            [chemistryCategories addObject:temp];
        else if ([sub isEqualToString:@"Biology"])
            [biologyCategories addObject:temp];
    }
    
    NSMutableArray *contents = [[NSMutableArray alloc] initWithObjects:[[NSMutableArray alloc] initWithObjects: chemistryCategories,
                                                                        physicsCategories,
                                                                        biologyCategories, nil], nil];
    NSMutableArray *subjects = [[NSMutableArray alloc] initWithObjects:@"Chemistry", @"Physics", @"Biology", nil];
    
    
    int totalTotal = 0;
    int totalTotalStars = 0;
    
    //Loopar igenom ett ämne i taget
    for (int a = 0; a < 3; a++) {
        //Loopar igenom alla kategorier i ämnet
        int loop = [[[contents objectAtIndex:0] objectAtIndex:a] count];
        
        for (int i = 0; i < loop; i++) {
            NSString *key = [NSString stringWithFormat:@"NatureCategory%iStars", [[[[[contents objectAtIndex:0] objectAtIndex:a] objectAtIndex:i] objectAtIndex:2] intValue]];
            int thisStars = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:key];
            totalTotal+=3;
            totalTotalStars+=thisStars;
        }
        
        //Lägg till mixed
        totalTotal+=3;
        int thisOne = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:[NSString stringWithFormat:@"NatureCategory%@Mixed", [subjects objectAtIndex:a]]];
        totalTotalStars+=thisOne;
    }
    //Master antimatte
    [[GameKitHelper sharedGameKitHelper] reportAchievementIdentifier:@"all_except_math" percentComplete:((float)totalTotalStars/(float)totalTotal)*100.0+0.5];
    
    totalTotalStars+=mathStars;
    totalTotal+=totalMathStars;
    
    
    //Master scientist
    [[GameKitHelper sharedGameKitHelper] reportAchievementIdentifier:@"master_scientist" percentComplete:((float)totalTotalStars/(float)totalTotal)*100.0+0.5];

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