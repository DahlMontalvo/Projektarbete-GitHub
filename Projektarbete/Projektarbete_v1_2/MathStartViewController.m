//
//  MathStartViewController.m
//  Projektarbete_v1_2
//
//  Created by Jonas Dahl on 9/12/12.
//
//

#import "MathStartViewController.h"

@interface MathStartViewController ()

@end

@implementation MathStartViewController

@synthesize operation;
@synthesize difficulty;
@synthesize start_countdown_date;
@synthesize quizArray;
@synthesize questionAtm;
@synthesize answer;
@synthesize correctAnswers;
@synthesize gameMode;
@synthesize countdownCounter;
@synthesize cancelCountdown;
@synthesize finalTime;
@synthesize interval;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)startButton:(id)sender {
    if ([operation isEqualToString:@"Fraction"]) {
        [self performSegueWithIdentifier:@"Quiz" sender:self];
    }
    else {
        [self performSegueWithIdentifier:@"Count" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"%@, %i, %@", operation, difficulty, gameMode);
    if ([[segue identifier] isEqualToString:@"Quiz"]) {
        MathQuizViewController *evc = [segue destinationViewController];
        evc.operation = operation;
        evc.difficulty = difficulty;
        evc.gameMode = gameMode;
    }
    else {
        MathExerciseViewController *evc = [segue destinationViewController];
        evc.operation = operation;
        evc.difficulty = difficulty;
        evc.gameMode = gameMode;
    }
}

@end
