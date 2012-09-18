//
//  MathResultsViewController.m
//  Projektarbete_v1_2
//
//  Created by Jonas Dahl on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MathResultsViewController.h"

@implementation MathResultsViewController
@synthesize results;
@synthesize resultsLabel;
@synthesize timeLabel;
@synthesize infoLabel;
@synthesize navItem;
@synthesize operation;
@synthesize difficulty;
@synthesize finalTime;
@synthesize gamemode;
@synthesize gamemodeLabel;
@synthesize highscoreLabel;
@synthesize starLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Hur många stjärnor får användaren? Ska presenteras grafiskt senare, och storas som highscoren.
    //Storar hur många stjärnor man har, tex 3 forKey StarsAddition2 då har man alltså 3 stjärnor på Addition lvl 2
    if (finalTime < ((difficulty * 100)*0.2) && results == 10) {
        starLabel.text = @"3 Stars!";
        if ([[[Singleton sharedSingleton] sharedPrefs] integerForKey:[NSString stringWithFormat:@"Stars%@%i",operation,difficulty] ] < 3) {
            [[[Singleton sharedSingleton] sharedPrefs] setInteger:3 forKey:[NSString stringWithFormat:@"Stars%@%i",operation,difficulty]];
        }
    } else if (finalTime < (difficulty * 100)*0.4 && results == 10) {
        starLabel.text = @"2 Stars!";
        if ([[[Singleton sharedSingleton] sharedPrefs] integerForKey:[NSString stringWithFormat:@"Stars%@%i",operation,difficulty] ] < 2) {
            [[[Singleton sharedSingleton] sharedPrefs] setInteger:2 forKey:[NSString stringWithFormat:@"Stars%@%i",operation,difficulty]];
        }
    } else if (finalTime < (difficulty * 100)*0.6 && results == 10) {
        starLabel.text = @"1 Star!";
        if ([[[Singleton sharedSingleton] sharedPrefs] integerForKey:[NSString stringWithFormat:@"Stars%@%i",operation,difficulty] ] < 1) {
            [[[Singleton sharedSingleton] sharedPrefs] setInteger:1 forKey:[NSString stringWithFormat:@"Stars%@%i",operation,difficulty]];
        }
    } else {
        starLabel.text = @"No stars this time! Haha! :(";
         [[[Singleton sharedSingleton] sharedPrefs] setInteger:0 forKey:[NSString stringWithFormat:@"Stars%@%i",operation,difficulty]];
    }
    
    [[[Singleton sharedSingleton] sharedPrefs] synchronize];
    
    int starsA = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:[NSString stringWithFormat:@"Stars%@1",operation]];
    int starsB = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:[NSString stringWithFormat:@"Stars%@2",operation]];
    int starsC = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:[NSString stringWithFormat:@"Stars%@3",operation]];
    int starsD = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:[NSString stringWithFormat:@"Stars%@4",operation]];
    int starsE = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:[NSString stringWithFormat:@"Stars%@5",operation]];
    
    int totalStars = starsA + starsB + starsC + starsD + starsE;
    
    [[[Singleton sharedSingleton] sharedPrefs] setInteger:totalStars forKey:[NSString stringWithFormat:@"TotalStars%@",operation]];

    [[[Singleton sharedSingleton] sharedPrefs] synchronize];
    navItem.hidesBackButton = YES;
    resultsLabel.text = [NSString stringWithFormat:@"%i/10", results];
    infoLabel.text = [NSString stringWithFormat:@"Completed in %@ level %i,", operation,difficulty];
    gamemodeLabel.text = gamemode;
    
    //Sparar Singletonvärde med tiden i en key med operationen och diffen, det mesta förklarar sig självt
    
    float previousHighscore = [[[Singleton sharedSingleton] sharedPrefs] floatForKey:[NSString stringWithFormat:@"%@%i",operation,difficulty]];
    
    timeLabel.text = [NSString stringWithFormat:@"in %.2f seconds",finalTime];
    if ((finalTime < previousHighscore || previousHighscore == 0) && [gamemode isEqualToString:@"Test"] && results == 10) {
        [[[Singleton sharedSingleton] sharedPrefs] setFloat:finalTime forKey:[NSString stringWithFormat:@"%@%i",operation,difficulty]];
        highscoreLabel.text = @"Highscore!";
    }
    
    //Sparar Global Stats
    int previousCompletedTests = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"CompletedTests"];
    int previousCompletedPractises = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"CompletedPractises"];

    
    
    if ([gamemode isEqualToString:@"Test"]) {
        [[[Singleton sharedSingleton] sharedPrefs] setInteger:previousCompletedTests+1 forKey:@"CompletedTests"];
    }
    
    if ([gamemode isEqualToString:@"Practise"]) {
        [[[Singleton sharedSingleton] sharedPrefs] setInteger:previousCompletedPractises+1 forKey:@"CompletedPractises"];
    }
    
    
}


- (void)viewDidUnload
{
    [self setResultsLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)continueButtonPressed:(id)sender {
    
    NSArray *viewControllers = [self.navigationController viewControllers];
    
    [self.navigationController popToViewController:[viewControllers objectAtIndex:1] animated:YES];
    
}
@end