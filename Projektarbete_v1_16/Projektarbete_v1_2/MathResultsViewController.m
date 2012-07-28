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
    
    navItem.hidesBackButton = YES;
    resultsLabel.text = [NSString stringWithFormat:@"%i/10", results];
    infoLabel.text = [NSString stringWithFormat:@"Completed in %@ level %i,", operation,difficulty];
    gamemodeLabel.text = gamemode;
    
    //Sparar Singletonvärde med tiden i en key med operationen och diffen, det mesta förklarar sig självt
    
    float previousHighscore = [[[Singleton sharedSingleton] sharedPrefs] floatForKey:[NSString stringWithFormat:@"%@%i",operation,difficulty]];
    
    if ((finalTime < previousHighscore || previousHighscore == 0) && [gamemode isEqualToString:@"Test"] && results == 10) {
        timeLabel.text = [NSString stringWithFormat:@"in %f seconds",finalTime];
        [[[Singleton sharedSingleton] sharedPrefs] setFloat:finalTime forKey:[NSString stringWithFormat:@"%@%i",operation,difficulty]];
        highscoreLabel.text = @"New Highscore!";
    }
    else {
        timeLabel.text = [NSString stringWithFormat:@"in %f",finalTime];
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

@end