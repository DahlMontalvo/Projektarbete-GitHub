//
//  ExerciseViewController.m
//  Projektarbete_v1_2
//
//  Created by Jonas Dahl on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MathExerciseViewController.h"

@implementation MathExerciseViewController

@synthesize operation;
@synthesize difficulty;
@synthesize start_countdown_date;
@synthesize quizArray;
@synthesize questionAtm;
@synthesize answer;
@synthesize countdownLabel;
@synthesize correctAnswers;
@synthesize correctAnswersLabel;
@synthesize numberLabel;
@synthesize exerciseLabel;
@synthesize nextButton;
@synthesize answerFromUser;
@synthesize navItem;
@synthesize gameMode;
@synthesize pauseButton;
@synthesize countdownCounter;
@synthesize cancelCountdown;
@synthesize finalTime;
@synthesize interval;
@synthesize decimalSignInserted;
@synthesize keyboarddot;
@synthesize testStarted;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)timer
{
    //RÄKNAR TIDEN UPPÅT
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:start_date];
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm:ss.S"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    NSString *timeString=[dateFormatter stringFromDate:timerDate];
    countdownLabel.text = timeString;
    

}

-(void)onTimerStart
{
    //NÄR STOPPURET STARTAS FÖRSTA GÅNGEN
    time_passed = 0;
    
    //Startdatum
    start_date = [NSDate date];
    
    //Startar en timer som uppdateras tio gånger i sekunden
    timer = [NSTimer timerWithTimeInterval:1.0/10.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
}

-(void)onPause
{
    //CALLA FÖR ATT PAUSA KLOCKAN
    //Räkna ut passerad tid
    if (testStarted == YES) {
          time_passed += [[NSDate date] timeIntervalSinceDate: start_date];
        
    }
  
    
    //Stanna klockan
    [timer invalidate];
}

-(void)onUnpause
{   
    //STARTAR ETT PAUSA UR
    //Nytt startdatum
    start_date = [NSDate date];
    
    //Starta timer för att uppdatera UIt
    timer = [NSTimer timerWithTimeInterval:1.0/10.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
}

-(void)onReset
{
    //STANNAR KLOCKAN FÖR EVIGT
    [timer invalidate];
    
    time_passed = 0;
    
    start_date = nil;
}

-(void)onTimer
{
    //UPPDATERAR UIt
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:start_date]+time_passed;
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm:ss.S"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    NSString *timeString=[dateFormatter stringFromDate:timerDate];
    countdownLabel.text = timeString;
    

    
}

- (void)countdownTimer
{
    [self setCountdownCounter:(5+5*difficulty)-fabs([start_countdown_date timeIntervalSinceNow])];
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:countdownCounter];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm:ss.S"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    NSString *timeString=[dateFormatter stringFromDate:timerDate];
    
    countdownLabel.text = timeString;
    if (countdownCounter <= 0) {
        [self nextButtonPressed];
    }
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (NSMutableArray *) newQuizArrayFromCountingOperation:(NSString *)localOperation andDifficulty:(int)localDifficulty numberOfQuestions:(int)num {
    
    NSMutableArray *questionsArray = [[NSMutableArray alloc] init];
    NSMutableArray *answersArray = [[NSMutableArray alloc] init];
    NSMutableArray *userAnswersArray = [[NSMutableArray alloc] init];
    NSMutableArray *localQuizArray = [[NSMutableArray alloc] initWithObjects:questionsArray, answersArray, userAnswersArray, nil];
    //Frågor placeras i quizArray[0]
    
    //Lite minnesplatser
    int number1; 
    int number2;
    int localAnswer;
    NSString *text;
    
    //En loop för varje fråga
    for (int i = 0; i < num; i++) {
        switch (localDifficulty) {
            case 1:
                number1 = (arc4random() % 10);
                number2 = (arc4random() % 10);
                break;
                
            case 2:
                number1 = arc4random() % 10 + 10;
                number2 = arc4random() % 10 + 10;
                break;
                
            case 3:
                number1 = arc4random() % 25 + 25;
                number2 = arc4random() % 25 + 25;
                break;
                
            case 4:
                number1 = arc4random() % 50+50;
                number2 = arc4random() % 50+50;
                break;
                
            case 5:
                number1 = arc4random() % 9000 + 1000;
                number2 = arc4random() % 9000 + 1000;
                break;
        }
        
        //Om nummer 1 är mindre än nummer 2 uppstår problem vid bla subtraktion
        if (number1 < number2) {
            float temp = number1;
            number1 = number2;
            number2 = temp;
        }
        
        //Division med noll fungerar inte så bra
        if (number2 == 0) {            
            number2 = 1;
        }
        
        if ([localOperation isEqualToString:@"Addition"]) {
            localAnswer = number1+number2;
            text = [NSString stringWithFormat:@"%i + %i", number1, number2];
        }
        else if ([localOperation isEqualToString:@"Subtraction"]) {
            localAnswer = number1-number2;
            text = [NSString stringWithFormat:@"%i - %i", number1, number2];  
        } 
        else if ([localOperation isEqualToString:@"Division"]) {
            if (number1%number2 != 0) {
                number1 = number1 - (number1%number2);
            }
            if (number1 < 0) {
                number1 = 0;
            }
            localAnswer = (float) number1 / (float) number2;
            text = [NSString stringWithFormat:@"%i / %i", number1, number2];  
        } 
        else if ([localOperation isEqualToString:@"Multiplication"]) {
            localAnswer = number1*number2;
            text = [NSString stringWithFormat:@"%i * %i", number1, number2];  
        }
        else if ([localOperation isEqualToString:@"Percent"]) {
            number1 = (arc4random() % 10)*10;
            localAnswer = number1*number2/100;
            text = [NSString stringWithFormat:@"%i%% of %i", number1, number2];  
        }
        else if ([localOperation isEqualToString:@"Fraction"]) {
            localAnswer = number1*number2;
            text = [NSString stringWithFormat:@"%i * %i", number1, number2];
        }
        else if ([localOperation isEqualToString:@"Equations"]) {
            localAnswer = number1*number2;
            text = [NSString stringWithFormat:@"%i * %i", number1, number2];  
        }
        else {
            text = @"";
            localAnswer = 0;
        }
        
        [[localQuizArray objectAtIndex:0] insertObject:text atIndex:i];
        [[localQuizArray objectAtIndex:1] insertObject:[NSNumber numberWithInt:localAnswer] atIndex:i];
        
    }
    
    return localQuizArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    testStarted = NO;
    
    cancelCountdown = NO;
    correctAnswers = 0;
    questionAtm = 0;
    
    //SAKER FÖR ATT STÄDA UPP
    //Tangentbord upp
    //[answerFromUser becomeFirstResponder];
    
    countdownLabel.text = @"";
    navItem.hidesBackButton = YES;
    [navItem setTitle:[NSString stringWithFormat:@"%@ in %@ %i",gameMode,operation,difficulty]];

    
    quizArray = [self newQuizArrayFromCountingOperation:operation andDifficulty:difficulty numberOfQuestions:10];

    if ([gameMode isEqualToString:@"Test"]) {
        //Exit ist för pause
        [pauseButton setTitle:@"Exit" forState:UIControlStateNormal];    
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"Done"]) {
        MathResultsViewController *rvc = [segue destinationViewController];
        rvc.results = correctAnswers;
        rvc.difficulty = difficulty;
        rvc.operation = operation;
        rvc.finalTime = finalTime;
        rvc.gamemode = gameMode;
    }
}


-(void)nextButtonPressed {
    decimalSignInserted = NO;
    [keyboarddot setEnabled:YES];
    testStarted = YES;
    questionAtm++;
    NSLog(@"Qatm = %i", questionAtm);
    
    if ([countdownTimer isValid]) {
        [countdownTimer invalidate];
        countdownTimer = nil;
    }
    
    //Vid test gäller andra puckar för klockan
    if ([gameMode isEqualToString:@"Test"]) {
        if (questionAtm > 0) {
            cancelCountdown = YES;
        }
        countdownCounter = 5+difficulty*5;
        countdownLabel.text = [NSString stringWithFormat:@"%i", (int)countdownCounter];
        countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f/20.0f
                                                                        target:self
                                                                      selector:@selector(countdownTimer)
                                                                      userInfo:nil
                                                                       repeats:YES];
    }
    if (questionAtm == 1) {
        if ([gameMode isEqualToString:@"Test"]) {
            testDate = [NSDate date];
        }
        else {
            //Skapa stoppur
            start_date = [NSDate date];
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0/20.0
                                                     target:self
                                                   selector:@selector(timer)
                                                   userInfo:nil
                                                    repeats:YES];
        }
        [nextButton setTitle:@"Next" forState:UIControlStateNormal];
    }
    else {
        //Rätta tidigare fråga
        int answerFromUserInt = [answerFromUser.text intValue];
        [[quizArray objectAtIndex:2] insertObject:[NSNumber numberWithInt:answerFromUserInt] atIndex:questionAtm-2];
        if (answerFromUserInt == [[[quizArray objectAtIndex:1] objectAtIndex:questionAtm-2] intValue]) {
            correctAnswers++;
        }
    }
    
    numberLabel.text = [NSString stringWithFormat:@"%i", questionAtm];
    correctAnswersLabel.text = [NSString stringWithFormat:@"%i/%i", correctAnswers, questionAtm-1];
    answerFromUser.text = @"";
    
    if (questionAtm == 10) {
        [nextButton setTitle:@"Done!" forState:UIControlStateNormal];
    }
    if (questionAtm == 11) {
        //Skickar med tiden till nästa view
        
        if ([gameMode isEqualToString:@"Test"]) {
            
            NSDate *currentDate = [NSDate date];
            NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:testDate];
            finalTime = timeInterval;
            NSLog(@"finaltime TEST: %f",finalTime);
            [timer invalidate];
            start_date = nil;
            testDate = nil;
            cancelCountdown = YES;
            questionAtm = 0;
            [self performSegueWithIdentifier:@"Done" sender:self];
            
        } 
        else if ([gameMode isEqualToString:@"Practise"]) {
        
            NSDate *currentDate = [NSDate date];
            NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:start_date]+time_passed;
            finalTime = timeInterval;
            NSLog(@"finaltime PRAC: %f",finalTime);
            [timer invalidate];
            start_date = nil;
            testDate = nil;
            questionAtm = 0;
            [self performSegueWithIdentifier:@"Done" sender:self];
        }
        
    }
    else {
        exerciseLabel.text = [[quizArray objectAtIndex:0] objectAtIndex:questionAtm-1];
        start_countdown_date = [NSDate date];
    }
}

-(void)addNumber:(int)numberToAdd {
    [answerFromUser setText:[NSString stringWithFormat:@"%@%i",answerFromUser.text,numberToAdd]];
}

- (IBAction)keyboard1:(id)sender {
    [self addNumber:1];
}

- (IBAction)keyboard2:(id)sender {
    [self addNumber:2];
}

- (IBAction)keyboard3:(id)sender {
    [self addNumber:3];
}

- (IBAction)keyboard4:(id)sender {
    [self addNumber:4];
}

- (IBAction)keyboard5:(id)sender {
    [self addNumber:5];
}

- (IBAction)keyboard6:(id)sender {
    [self addNumber:6];
}

- (IBAction)keyboard7:(id)sender {
    [self addNumber:7];
}

- (IBAction)keyboard8:(id)sender {
    [self addNumber:8];
}

- (IBAction)keyboard9:(id)sender {
    [self addNumber:9];
}

- (IBAction)keyboarddot:(id)sender {
    if (decimalSignInserted == NO)
        [answerFromUser setText:[NSString stringWithFormat:@"%@.",answerFromUser.text]];
    decimalSignInserted = YES;
    [keyboarddot setEnabled:NO];
}

- (IBAction)keyboard0:(id)sender {
    [self addNumber:0];
}

- (IBAction)keyboardback:(id)sender {
    NSString *string = [answerFromUser text];
    if ([string hasSuffix:@"."]) {
        decimalSignInserted = NO;
        [keyboarddot setEnabled:YES];
    }
    if ( [string length] > 0)
        string = [string substringToIndex:[string length] - 1];
    answerFromUser.text = string;
}

- (IBAction)nextButton:(id)sender {
    
    [self nextButtonPressed];
    
}

// PAUSE OCH ACTIONSHEET

-(IBAction)pausePressed:(id)sender {
    
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Quiz paused" delegate:self cancelButtonTitle:@"Resume" destructiveButtonTitle:@"Exit" otherButtonTitles:@"Restart quiz", nil, nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[popupQuery showInView:self.view];
    
    NSLog(@"Pausad!");
    //Stanna klockan!
	
    
    if ([gameMode isEqualToString:@"Practise"]) {
        [timer invalidate];
        timer = nil;
        [self onPause];
    }

    
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

	if (buttonIndex == 0) {
        cancelCountdown = YES;
        
        [timer invalidate];
        timer = nil;
        
        [countdownTimer invalidate];
        countdownTimer = nil;
        [self onReset];
        
        if ([self.navigationController.viewControllers objectAtIndex:1] != nil) {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }
        else {
            [self performSegueWithIdentifier:@"exerciseToMain" sender:self];
        }
		
	} else if (buttonIndex == 1) {
        //Restarta 
        questionAtm = 0;
        [[quizArray objectAtIndex:1] removeAllObjects];
        correctAnswersLabel.text = @"";
        numberLabel.text = @"";
        exerciseLabel.text = @"";
		[nextButton setTitle:@"Start!" forState:UIControlStateNormal];
        answerFromUser.text = @"";
        correctAnswers = 0;
        
        [countdownTimer invalidate];
        countdownTimer = nil;
        [timer invalidate];
        timer = nil;
        cancelCountdown = YES;
        countdownLabel.text = @"0";
        [self onReset];
        
        countdownLabel.text = @"";
    
	} else if (buttonIndex == 2) {
		//Starta klockan!!!!
        if ([gameMode isEqualToString:@"Practise"]) {
            [self onUnpause];
           
            if (testStarted == YES) {
                timer = [NSTimer scheduledTimerWithTimeInterval:1.0/10.0
                                                         target:self
                                                       selector:@selector(onTimer)
                                                       userInfo:nil
                                                        repeats:YES];
            }
            
        }
    } 
}

- (void)viewDidUnload
{
    [self setCorrectAnswersLabel:nil];
    [self setExerciseLabel:nil];
    [self setAnswerFromUser:nil];
    [self setExerciseLabel:nil];
    [self setNextButton:nil];
    [self setNumberLabel:nil];
    [self setCountdownLabel:nil];
    [self setPauseButton:nil];
    
    [self setKeyboarddot:nil];
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
