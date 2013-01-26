//
//  MathDetailViewController.m
//  Simple Science
//
//  Copyright (c) 2013 Jonas Dahl & Philip Montalvo. All rights reserved.
//

#import "MathDetailViewController.h"
#import "Flurry.h"

@implementation MathDetailViewController

@synthesize startButton, navigationLabel, operation, modeLabel, difficultyButtons, buttonFive, buttonFour, buttonOne, buttonThree, buttonTwo, buttonPractise, buttonTest, gamemodeButtons, selectedGamemode, selectedOperation;

#pragma mark - Initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View management
- (void)viewDidLoad {
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
    navigationLabel.text = operation;
}

- (void)viewDidDisappear:(BOOL)animated {
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

- (void)viewDidUnload {
    [self setNavigationLabel:nil];
    [self setStartButton:nil];
    [self setButtonOne:nil];
    [self setButtonTwo:nil];
    [self setButtonThree:nil];
    [self setButtonFour:nil];
    [self setButtonFive:nil];
    [self setButtonPractise:nil];
    [self setButtonTest:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Others
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
