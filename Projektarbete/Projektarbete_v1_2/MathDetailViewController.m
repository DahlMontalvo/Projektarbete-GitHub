//
//  MathDetailViewController.m
//  Projektarbete_v1_2
//
//  Created by Jonas Dahl on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MathDetailViewController.h"

@implementation MathDetailViewController
@synthesize startButton;

@synthesize testingButton;
@synthesize gameButton;
@synthesize practiseButton;
@synthesize navigationLabel;
@synthesize operation;
@synthesize modeLabel;

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
    
    [gamemodeSegmentedControl setEnabled:NO];
    [practiseButton setEnabled:NO];
    [testingButton setEnabled:NO];
    [modeLabel setEnabled:NO];
    [startButton setEnabled:NO];
    
    [practiseTextField setTextColor:[UIColor lightGrayColor]];
    [testTextField setTextColor:[UIColor lightGrayColor]];
    
    //self.navigationItem.title = operation;
    navigationLabel.text = operation;
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    [difficultySegmentedControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ToQuiz"]) {
        MathQuizViewController *evc = [segue destinationViewController];
        evc.operation = operation;
        evc.difficulty = (difficultySegmentedControl.selectedSegmentIndex+1);
        evc.gameMode = [gamemodeSegmentedControl titleForSegmentAtIndex:gamemodeSegmentedControl.selectedSegmentIndex];
    }
    else {
        MathExerciseViewController *evc = [segue destinationViewController];
        evc.operation = operation;
        evc.difficulty = (difficultySegmentedControl.selectedSegmentIndex+1);
        evc.gameMode = [gamemodeSegmentedControl titleForSegmentAtIndex:gamemodeSegmentedControl.selectedSegmentIndex];
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
    [practiseButton setEnabled:YES];
    [testingButton setEnabled:YES];
    [modeLabel setEnabled:YES];
    [practiseTextField setTextColor:[UIColor blackColor]];
    [testTextField setTextColor:[UIColor blackColor]];
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
@end
