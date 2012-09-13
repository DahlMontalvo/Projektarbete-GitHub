//
//  MathQuizViewController.m
//  Projektarbete_v1_2
//
//  Created by Jonas Dahl on 9/12/12.
//
//

#import "MathQuizViewController.h"

@interface MathQuizViewController ()

@end

@implementation MathQuizViewController
@synthesize buttonFour;
@synthesize buttonTwo;
@synthesize buttonThree;

@synthesize operation;
@synthesize difficulty;
@synthesize start_countdown_date;
@synthesize countdownLabel;
@synthesize correctAnswersLabel;
@synthesize buttonOne;
@synthesize operationLabel;
@synthesize pauseButton;
@synthesize numeratorOneLabel;
@synthesize numeratorTwoLabel;
@synthesize denominatorOneLabel;
@synthesize denominatorTwoLabel;
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
    
    
}

- (NSMutableArray *)simplifyFractionFromArray:(NSMutableArray *)array {
    int a = [[array objectAtIndex:0] intValue];
    int b = [[array objectAtIndex:1] intValue];
    int s;
    int gcf = 1;
    if (a > b)
        s = b;
    else
        s = a;
    for (int i = s; i > 0; i--) {
        if ((a%i == 0) && (b%i == 0)) {
            gcf = i;
            break;
        }
    }
    
    if (gcf == 1) {
        //Går inte att förenkla mer
        return [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:a], [NSNumber numberWithInt:b], nil];
    }
    else {
        //Dela med gcf och fortsätt...
        a = a/gcf;
        b = b/gcf;
        return [self simplifyFractionFromArray:[[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:a], [NSNumber numberWithInt:b], nil]];
    }
}

- (void)viewDidLoad
{
    //Skapa frågor
    
    NSMutableArray *questionsArray = [[NSMutableArray alloc] init];
    NSMutableArray *answersArray = [[NSMutableArray alloc] init];
    int numeratorOne;
    int numeratorTwo;
    int denominatorOne;
    int denominatorTwo;
    int countingOperation;
    int answerNumerator;
    int answerDenominator;
    for (int i = 0; i < 10; i++) {
        numeratorOne = arc4random() % 9 + 1;
        numeratorTwo = arc4random() % 9 + 1;
        denominatorOne = arc4random() % 9 + 1;
        denominatorTwo = arc4random() % 9 + 1;
        bool continueLoop = true;
        while (continueLoop) {
            countingOperation = arc4random() % 3 + 1;
            if (countingOperation == 3 && difficulty < 4) {
                continueLoop = YES;
            }
            else {
                continueLoop = NO;
            }
        }
        
        NSMutableArray *contents = [[NSMutableArray alloc] init];
        [contents insertObject:[NSNumber numberWithInt:numeratorOne] atIndex:0];
        [contents insertObject:[NSNumber numberWithInt:numeratorTwo] atIndex:1];
        [contents insertObject:[NSNumber numberWithInt:denominatorOne] atIndex:2];
        [contents insertObject:[NSNumber numberWithInt:denominatorTwo] atIndex:3];
        [contents insertObject:[NSNumber numberWithInt:countingOperation] atIndex:4];
        [questionsArray insertObject:contents atIndex:i];
        //Räknesätt: 1 = plus 2 = minus 3 = delat 4 = gånger "Det heter multiplikation" //Kalle
        switch (countingOperation) {
            case 1:
                answerNumerator = denominatorTwo*numeratorOne+denominatorOne*numeratorTwo;
                answerDenominator = denominatorOne*denominatorTwo;
                break;
                
            case 2:
                answerNumerator = denominatorTwo*numeratorOne-denominatorOne*numeratorTwo;
                answerDenominator = denominatorOne*denominatorTwo;
                break;
                
            case 3:
                answerNumerator = numeratorOne*denominatorTwo;
                answerDenominator = denominatorOne*numeratorTwo;
                break;
                
            case 4:
                answerNumerator = numeratorOne*numeratorTwo;
                answerDenominator = denominatorOne*denominatorTwo;
                break;
                
            default:
                answerNumerator = numeratorOne*numeratorTwo;
                answerDenominator = denominatorOne*denominatorTwo;
                break;
        }
        [answersArray insertObject:[[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:answerNumerator], [NSNumber numberWithInt:answerDenominator], nil] atIndex:i];
    }
    
    numeratorOneLabel.text = [NSString stringWithFormat:@"%@", [[questionsArray objectAtIndex:0] objectAtIndex:0]];
    numeratorTwoLabel.text = [NSString stringWithFormat:@"%@", [[questionsArray objectAtIndex:0] objectAtIndex:1]];
    denominatorOneLabel.text = [NSString stringWithFormat:@"%@", [[questionsArray objectAtIndex:0] objectAtIndex:2]];
    denominatorTwoLabel.text = [NSString stringWithFormat:@"%@", [[questionsArray objectAtIndex:0] objectAtIndex:3]];
    
    buttonOne.titleLabel.text = [NSString stringWithFormat:@"%i / %i", [[[answersArray objectAtIndex:0] objectAtIndex:0] intValue], [[[answersArray objectAtIndex:0] objectAtIndex:1] intValue]];
    NSLog(@"%i, %i", [[[answersArray objectAtIndex:0] objectAtIndex:0] intValue], [[[answersArray objectAtIndex:0] objectAtIndex:1] intValue]);
    
    
    if ([[[questionsArray objectAtIndex:0] objectAtIndex:4] intValue] == 1) {
        operationLabel.text = @"+";
    }
    else if ([[[questionsArray objectAtIndex:0] objectAtIndex:4] intValue] == 2) {
        operationLabel.text = @"-";
    }
    else if ([[[questionsArray objectAtIndex:0] objectAtIndex:4] intValue] == 3) {
        operationLabel.text = @"/";
    }
    else if ([[[questionsArray objectAtIndex:0] objectAtIndex:4] intValue] == 4) {
        operationLabel.text = @"*";
    }

    [self nextButtonPressed];
    
    //Skapa svar (1 korrekt och 3 felaktiga - viktigt att de felaktiga verkligen är FEL)
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)nextButtonPressed {
    
    //decimalSignInserted = NO;
    questionAtm++;
    
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
    }
    correctAnswersLabel.text = [NSString stringWithFormat:@"%i/%i", correctAnswers, questionAtm-1];
    
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
        //exerciseLabel.text = [[quizArray objectAtIndex:0] objectAtIndex:questionAtm-1];
        start_countdown_date = [NSDate date];
    }
     
}

- (void)viewDidUnload
{
    [self setCountdownLabel:nil];
    [self setCorrectAnswersLabel:nil];
    [self setPauseButton:nil];
    [self setOperationLabel:nil];
    [self setNumeratorOneLabel:nil];
    [self setNumeratorTwoLabel:nil];
    [self setDenominatorOneLabel:nil];
    [self setDenominatorTwoLabel:nil];
    [self setButtonOne:nil];
    [self setButtonTwo:nil];
    [self setButtonThree:nil];
    [self setButtonFour:nil];
    [self setButtonTwo:nil];
    [self setButtonThree:nil];
    [self setButtonFour:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)pauseButton:(id)sender {
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

- (IBAction)buttonOne:(id)sender {
}

- (IBAction)buttonTwo:(id)sender {
}

- (IBAction)buttonThree:(id)sender {
}

- (IBAction)buttonFour:(id)sender {
}
@end
