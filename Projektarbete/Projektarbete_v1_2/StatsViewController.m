//
//  StatsViewController.m
//  Simple Science
//
//  Copyright (c) 2013 Jonas Dahl & Philip Montalvo. All rights reserved.
//

#import "StatsViewController.h"

@implementation StatsViewController
@synthesize completedTestsLabel, doneButton, delegate, subject, tenOutOfTensLabel, bestHighscoreLabel, mostPlayedSubjectLabel, overallProgressLabel, averageCorrectQuestionsLabel, averageHighscoreLabel, infoButton, leaderboardsButton;

#pragma mark - Initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

#pragma mark - View management
-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)refreshView {
    NSLog(@"%@", [[[Singleton sharedSingleton] sharedPrefs] dictionaryRepresentation]);
    
    int completedTests = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"CompletedTests"];
    int tenOutOfTens = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"TenOutOfTens"];
    int bestHighscore = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"BestHighscore"];
    int totalCorrectQuestions = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"TotalCorrect"];
    int totalScore = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"TotalHighscore"];
    
    int timesPlayedMa = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"TimesPlayedMa"];
    int timesPlayedCh = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"TimesPlayedChemistry"];
    int timesPlayedBi = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"TimesPlayedBiology"];
    int timesPlayedPh = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"TimesPlayedPhysics"];
    
    if (timesPlayedMa > timesPlayedCh && timesPlayedMa > timesPlayedBi && timesPlayedMa > timesPlayedPh) {
        mostPlayedSubjectLabel.text = @"Ma";
    }
    
    else if (timesPlayedBi > timesPlayedCh && timesPlayedBi > timesPlayedMa && timesPlayedBi > timesPlayedPh) {
        mostPlayedSubjectLabel.text = @"Bi";
    }
    
    else if (timesPlayedPh > timesPlayedCh && timesPlayedPh > timesPlayedMa && timesPlayedPh > timesPlayedBi) {
        mostPlayedSubjectLabel.text = @"Ph";
    }
    
    else if (timesPlayedCh > timesPlayedMa && timesPlayedCh > timesPlayedBi && timesPlayedCh > timesPlayedPh) {
        mostPlayedSubjectLabel.text = @"Ch";
    }
    
    else {
        mostPlayedSubjectLabel.text = @"None";
    }
    
    if (completedTests > 0) {
        
        float averageCorrectQuestions = (float)totalCorrectQuestions / (float)completedTests;
        int averageScore = totalScore / completedTests;
        
        averageCorrectQuestionsLabel.text = [NSString stringWithFormat:@"%.1f",averageCorrectQuestions];
        averageHighscoreLabel.text = [NSString stringWithFormat:@"%i",averageScore];
    } else {
        averageCorrectQuestionsLabel.text = @"0";
        averageHighscoreLabel.text = @"0";
    }
    
    completedTestsLabel.text = [NSString stringWithFormat:@"%i",completedTests];
    tenOutOfTensLabel.text = [NSString stringWithFormat:@"%i", tenOutOfTens];
    bestHighscoreLabel.text = [NSString stringWithFormat:@"%i", bestHighscore];
    
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
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
    
    //Lägger in kategorierna med deras labels
    NSMutableArray *contents = [[NSMutableArray alloc] initWithObjects:[[NSMutableArray alloc] initWithObjects: chemistryCategories,
                                                                        physicsCategories,
                                                                        biologyCategories, nil], nil];
    NSMutableArray *subjects = [[NSMutableArray alloc] initWithObjects:@"Chemistry", @"Physics", @"Biology", nil];
        
    int total = 0;
    int stars = 0;
        float share = 0;
    
    //Loopar igenom ett ämne i taget
    for (int a = 0; a < 3; a++) {
        //Loopar igenom alla kategorier i ämnet
        int loop = [[[contents objectAtIndex:0] objectAtIndex:a] count];
        
        for (int i = 0; i < loop; i++) {
            NSString *key = [NSString stringWithFormat:@"NatureCategory%iStars", [[[[[contents objectAtIndex:0] objectAtIndex:a] objectAtIndex:i] objectAtIndex:2] intValue]];
            int thisStars = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:key];
            total+=3;
            stars+=thisStars;
        }
        //Lägg till mixed
        total+=3;
        stars+=[[[Singleton sharedSingleton] sharedPrefs] integerForKey:[NSString stringWithFormat:@"NatureCategory%@Mixed", [subjects objectAtIndex:a]]];
    }
    
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
            stars+=thisStars;
        }
    }
    
    if (total != 0)
        share = (float)stars/(float)total;
    else
        share = 0;
    
    share*=100;
    
    overallProgressLabel.text = [NSString stringWithFormat:@"%i %%", (int)(share+.5)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refreshView];
}

- (void)viewDidUnload {
    [self setOverallProgressLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Others
-(IBAction)done:(id)sender {
    [self.delegate StatsViewControllerDidDone:self];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)physicsButtonPressed:(id)sender {
    subject = @"Physics";
    [self performSegueWithIdentifier:@"ToNatureStats" sender:self];
}

- (IBAction)chemistryButtonPressed:(id)sender {
    subject = @"Chemistry";
    [self performSegueWithIdentifier:@"ToNatureStats" sender:self];
}

- (IBAction)biologyButtonPressed:(id)sender {
    subject = @"Biology";
    [self performSegueWithIdentifier:@"ToNatureStats" sender:self];
}

- (IBAction)downButtonPressed:(id)sender {
    [self.parentViewController dismissModalViewControllerAnimated:YES];
}

-(IBAction)clearAll:(id)sender {
    
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Are you sure that you want to delete all stats?" delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:@"Yes" otherButtonTitles:nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[popupQuery showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
	if (buttonIndex == 0) {
        NSDate *lastSyncDate = [[[Singleton sharedSingleton] sharedPrefs] objectForKey:@"LastSyncDate"];
        int launchCount = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"LaunchCount"];
        [[[Singleton sharedSingleton] sharedPrefs] setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];
        [[[Singleton sharedSingleton] sharedPrefs] setObject:lastSyncDate forKey:@"LastSyncDate"];
        [[[Singleton sharedSingleton] sharedPrefs] setInteger:launchCount forKey:@"LaunchCount"];
        [[[Singleton sharedSingleton] sharedPrefs] synchronize];
    
        [self refreshView];
    }
    
} 

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *operation = [segue identifier];
    if ([operation isEqualToString:@"ToNatureStats"]) {
        NatureStatsViewController *evc = [segue destinationViewController];
        evc.subject = subject;
    }
    else {
        MathStatsViewController *evc = [segue destinationViewController];
        evc.operation = operation;
    }
}

-(IBAction)infoButtonPressed:(id)sender {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Stats Info"
                                                      message:@"Math difficulties 1 & 2 have been excluded from the global stats since they can give an excessively high result. The overall progress will still though include them."
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
}

- (IBAction) leaderboards:(id)sender
{
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
    if (leaderboardController != NULL)
    {
        //leaderboardController.category = self.currentLeaderBoard;
        leaderboardController.category = nil;
        leaderboardController.timeScope = GKLeaderboardTimeScopeWeek;
        leaderboardController.leaderboardDelegate = self;
        [self presentModalViewController: leaderboardController animated: YES];
    }
}
- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [self dismissModalViewControllerAnimated: YES];
    
}

@end
