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
    int minus = 20-finalTime;
    if (minus < 0) minus = 0;
    minus*=45;
    scoreScore = (score / sqrt(finalTime)*447.2135956)-minus; //Copyright Philip Montalvo
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
    [GameKitHelper submitAndAddScore:scoreScore];
    
    [appDelegate readCategoriesFromDatabase];
    
    //Samla underkategorierna i sina arrayer beroende på överkategori
    NSMutableArray *biologyCategories = [[NSMutableArray alloc] init];
    NSMutableArray *chemistryCategories = [[NSMutableArray alloc] init];
    NSMutableArray *physicsCategories = [[NSMutableArray alloc] init];
    
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
    
    int total = 0;
    int totalStars = 0;
    int chemistryStars = 0;
    int totalChemistryStars = 0;
    int physicsStars = 0;
    int totalPhysicsStars = 0;
    int biologyStars = 0;
    int totalBiologyStars = 0;
    
    //Loopar igenom ett ämne i taget
    for (int a = 0; a < 3; a++) {
        //Loopar igenom alla kategorier i ämnet
        int loop = [[[contents objectAtIndex:0] objectAtIndex:a] count];
        
        for (int i = 0; i < loop; i++) {
            NSString *key = [NSString stringWithFormat:@"NatureCategory%iStars", [[[[[contents objectAtIndex:0] objectAtIndex:a] objectAtIndex:i] objectAtIndex:2] intValue]];
            int thisStars = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:key];
            total+=3;
            totalStars+=thisStars;
            //Chemistry
            if (a == 0) {
                chemistryStars+=thisStars;
                totalChemistryStars+=3;
            }
            //Physics
            else if (a == 1) {
                totalPhysicsStars+=3;
                physicsStars+=thisStars;
            }
            //Chemistry
            else if (a == 2) {
                totalBiologyStars+=3;
                biologyStars+=thisStars;
            }
        }
        
        //Lägg till mixed
        total+=3;
        int thisOne = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:[NSString stringWithFormat:@"NatureCategory%@Mixed", [subjects objectAtIndex:a]]];
        totalStars+=thisOne;
        
        //Chemistry
        if (a == 0) {
            chemistryStars+=thisOne;
            totalChemistryStars+=3;
        }
        //Physics
        else if (a == 1) {
            totalPhysicsStars+=3;
            physicsStars+=thisOne;
        }
        //Chemistry
        else if (a == 2) {
            totalBiologyStars+=3;
            biologyStars+=thisOne;
        }
    }
    
    //Master antimatte
    [[GameKitHelper sharedGameKitHelper] reportAchievementIdentifier:@"all_except_math" percentComplete:((float)totalStars/(float)total)*100.0+0.5];
    
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
            totalStars+=thisStars;
        }
    }
    
    /* *****************
     
         Achievements 
     
       ***************** */
    
    
    if ([subject isEqualToString:@"Physics"] && stars == 3) {
        //Speed of light
        [[GameKitHelper sharedGameKitHelper] reportAchievementIdentifier:@"speed_of_light" percentComplete:100.0];
    }
    
    if ([subject isEqualToString:@"Biology"] && stars == 3) {
        //Natural Selection
        [[GameKitHelper sharedGameKitHelper] reportAchievementIdentifier:@"natural_selection" percentComplete:100.0];
    }
    
    if ([subject isEqualToString:@"Chemistry"] && stars == 3) {
        //Chemists have solutions
        [[GameKitHelper sharedGameKitHelper] reportAchievementIdentifier:@"chemists_have_solutions" percentComplete:100.0];
    }
    if (stars == 1) {
        //It's something
        [[GameKitHelper sharedGameKitHelper] reportAchievementIdentifier:@"its_something" percentComplete:100.0];
    }
    if (stars == 2) {
        //Improvement
        [[GameKitHelper sharedGameKitHelper] reportAchievementIdentifier:@"improvement" percentComplete:100.0];
    }
    
    //Apex Predator
    [[GameKitHelper sharedGameKitHelper] reportAchievementIdentifier:@"apex_predator" percentComplete:((float)biologyStars/(float)totalBiologyStars)*100.0+0.5];
    //Master of Physics
    [[GameKitHelper sharedGameKitHelper] reportAchievementIdentifier:@"master_of_physics" percentComplete:((float)physicsStars/(float)totalPhysicsStars)*100.0+0.5];
    //Master of Chemistry
    [[GameKitHelper sharedGameKitHelper] reportAchievementIdentifier:@"master_of_chemistry" percentComplete:((float)chemistryStars/(float)totalChemistryStars)*100.0+0.5];
    
    //Master scientist
    [[GameKitHelper sharedGameKitHelper] reportAchievementIdentifier:@"master_scientist" percentComplete:((float)totalStars/(float)total)*100.0+0.5];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
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
