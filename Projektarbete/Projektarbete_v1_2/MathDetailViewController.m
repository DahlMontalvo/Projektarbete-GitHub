//
//  MathDetailViewController.m
//  Projektarbete_v1_2
//
//  Created by Jonas Dahl on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MathDetailViewController.h"
#import "Flurry.h"

@implementation MathDetailViewController
@synthesize startButton;

@synthesize testingButton;
@synthesize gameButton;
@synthesize practiseButton;
@synthesize navigationLabel;
@synthesize operation;
@synthesize modeLabel;
@synthesize starsImage;
@synthesize starsLabel, difficultyButtons, buttonFive, buttonFour, buttonOne, buttonThree, buttonTwo, buttonPractise, buttonTest, gamemodeButtons, selectedGamemode, selectedOperation;

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
    
    difficultyButtons = [[NSMutableArray alloc] initWithObjects:buttonOne, buttonTwo, buttonThree, buttonFour, buttonFive, nil];
    //Följande rad initialiserar - ta inte bort!
    [self buttonPressed:0];
    
    gamemodeButtons = [[NSMutableArray alloc] initWithObjects:buttonPractise, buttonTest, nil];
    //Följande rad initialiserar - ta inte bort!
    [self buttonGamemodePressed:0];
    
    [buttonPractise setEnabled:NO];
    [buttonTest setEnabled:NO];
    [modeLabel setEnabled:NO];
    [startButton setEnabled:NO];
    
    
    
    [practiseTextField setTextColor:[UIColor lightGrayColor]];
    [testTextField setTextColor:[UIColor lightGrayColor]];
    [starsLabel setTextColor:[UIColor lightGrayColor]];
    
    //self.navigationItem.title = operation;
    navigationLabel.text = operation;
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSDictionary *eventParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     @"Math", @"Subject",
     operation, @"CategoryName",
     selectedGamemode, @"GameMode",
     [NSString stringWithFormat:@"%i", selectedOperation], @"Difficulty",
     nil];
    NSLog(@"Dict: %@", eventParams);
    [Flurry logEvent:@"Test_started" withParameters:eventParams];
    
    if ([[segue identifier] isEqualToString:@"ToQuiz"]) {
        MathQuizViewController *evc = [segue destinationViewController];
        evc.operation = operation;
        evc.difficulty = selectedOperation;
        evc.gameMode = selectedGamemode;
    }
    else {
        MathExerciseViewController *evc = [segue destinationViewController];
        evc.operation = operation;
        evc.difficulty = selectedOperation;
        evc.gameMode = selectedGamemode;
    }
     
}

- (void)viewDidUnload
{
    difficultySegmentedControl = nil;
    difficultySegmentedControl = nil;
    [self setTestingButton:nil];
    [self setGameButton:nil];
    [self setPractiseButton:nil];
    [self setNavigationLabel:nil];
    [self setStartButton:nil];
    [self setStarsImage:nil];
    [self setStarsLabel:nil];
    [self setButtonOne:nil];
    [self setButtonTwo:nil];
    [self setButtonThree:nil];
    [self setButtonFour:nil];
    [self setButtonFive:nil];
    [self setButtonPractise:nil];
    [self setButtonTest:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)difficultySegmentedControl:(id)sender {
    [gamemodeSegmentedControl setEnabled:YES];
   // [practiseButton setEnabled:YES];
   // [testingButton setEnabled:YES];
    

}

- (IBAction)gamemodeSegmentedControl:(id)sender {
    [startButton setEnabled:YES];
   

}

- (IBAction)backButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)startButton:(id)sender {
    if ([operation isEqualToString:@"Fraction"] ||
        [operation isEqualToString:@"Equations"] ||
        [operation isEqualToString:@"Percent"]) {
        [self performSegueWithIdentifier:@"ToQuiz" sender:self];
    }
    else {
        [self performSegueWithIdentifier:@"ToCount" sender:self];
    }
}

- (void)buttonPressed:(NSInteger)activeButtonIndex {
    [buttonPractise setEnabled:YES];
    [buttonTest setEnabled:YES];
    for (int i = 0; i < [difficultyButtons count]; i++) {
        DifficultySegmentedControlButtonController *button = [difficultyButtons objectAtIndex:i];
        if (i == activeButtonIndex-1) {
            [button setPressed:YES];
            selectedOperation = [[button titleForState:UIControlStateNormal] intValue];
            [modeLabel setEnabled:YES];
            [practiseTextField setTextColor:[UIColor blackColor]];
            [testTextField setTextColor:[UIColor blackColor]];
            [starsLabel setTextColor:[UIColor blackColor]];
            
            int stars = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:[NSString stringWithFormat:@"Stars%@%i",operation,selectedOperation]];
            
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
            
            starsImage.image = [UIImage imageNamed:name];
        } else {
            [button setPressed:NO];
        }
    }
}

- (void)buttonGamemodePressed:(NSInteger)activeButtonIndex {
    for (int i = 0; i < [gamemodeButtons count]; i++) {
        GamemodeSegmentedControlButtonController *button = [gamemodeButtons objectAtIndex:i];
        if (i == activeButtonIndex-1) {
            [button setPressed:YES];
            [startButton setEnabled:YES];
            selectedGamemode = [button titleForState:UIControlStateNormal];
        } else {
            [button setPressed:NO];
        }
    }
}

- (IBAction)buttonOnePressed:(id)sender { [self buttonPressed:1]; }
- (IBAction)buttonTwoPressed:(id)sender { [self buttonPressed:2]; }
- (IBAction)buttonThreePressed:(id)sender { [self buttonPressed:3]; }
- (IBAction)buttonFourPressed:(id)sender { [self buttonPressed:4]; }
- (IBAction)buttonFivePressed:(id)sender { [self buttonPressed:5]; }
- (IBAction)buttonPractisePressed:(id)sender { [self buttonGamemodePressed:1]; }
- (IBAction)buttonTestPressed:(id)sender { [self buttonGamemodePressed:2]; }

@end
