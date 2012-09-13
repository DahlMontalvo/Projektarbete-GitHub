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
@synthesize correctButton;
@synthesize answersArray;
@synthesize questionArray;
@synthesize correctString;

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
        if (((a%i == 0) && (b%i == 0)) || ((a%(-1*i) == 0) && (b%(-1*i) == 0)) || ((a%(-1*i) == 0) && (b%(1*i) == 0)) || ((a%(1*i) == 0) && (b%(-1*i) == 0))) {
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

-(void)updateButtonsWithCorrectString:(NSString *)correctString {
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithObjects:buttonOne, buttonTwo, buttonThree, buttonFour, nil];
    //Vilken ska vara rätt? 0-3
    correctButton = arc4random() % 3;
    UIButton *button;
    for (int i = 0; i < 4; i++) {
        button = [buttons objectAtIndex:i];
        if (i == correctButton) {
            [button setTitle:correctString forState:UIControlStateNormal];
        }
        else {
            [button setTitle:[NSString stringWithFormat:@"%i / %i", arc4random() % 9 + 1, arc4random() % 9 + 1] forState:UIControlStateNormal];
        }
    }
}

-(BOOL)checkIfCorrect:(int)buttonID {
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithObjects:buttonOne, buttonTwo, buttonThree, buttonFour, nil];
    UIButton *button = [buttons objectAtIndex:buttonID];
    if ([[[button titleLabel] text] isEqualToString:correctString]) {
        return YES;
    }
    return NO;
}

- (void)viewDidLoad
{
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
    questionArray = [[NSMutableArray alloc] init];
    answersArray = [[NSMutableArray alloc] init];
    correctAnswers = 0;
    //Skapa frågor
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
            if ((countingOperation == 3 || countingOperation == 3) && difficulty < 4) {
                continueLoop = YES;
            }
            else {
                continueLoop = NO;
            }
        }
        if (difficulty == 1) {
            denominatorOne = denominatorTwo;
            countingOperation = 1;
        }
        else if (difficulty == 2) {
            denominatorOne = denominatorTwo;
        }
        
        [questionArray insertObject:[[NSMutableArray alloc] initWithObjects:
                                 [NSNumber numberWithInt:numeratorOne],
                                 [NSNumber numberWithInt:numeratorTwo],
                                 [NSNumber numberWithInt:denominatorOne],
                                 [NSNumber numberWithInt:denominatorTwo],
                                 [NSNumber numberWithInt:countingOperation], nil] atIndex:i];
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
        
        NSMutableArray *temp = [self simplifyFractionFromArray:[[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:answerNumerator], [NSNumber numberWithInt:answerDenominator], nil]];
        
        [answersArray insertObject:temp atIndex:i];
    }
    
    questionAtm = 0;
    
    [self presentNextQuestion];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)presentNextQuestion {
    
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
    
    numeratorOneLabel.text = [NSString stringWithFormat:@"%i", [[[questionArray objectAtIndex:questionAtm] objectAtIndex:0] intValue]];
    numeratorTwoLabel.text = [NSString stringWithFormat:@"%i", [[[questionArray objectAtIndex:questionAtm] objectAtIndex:1] intValue]];
    denominatorOneLabel.text = [NSString stringWithFormat:@"%i", [[[questionArray objectAtIndex:questionAtm] objectAtIndex:2] intValue]];
    denominatorTwoLabel.text = [NSString stringWithFormat:@"%i", [[[questionArray objectAtIndex:questionAtm] objectAtIndex:3] intValue]];
    NSLog(@"%i, %i, 2", [[[questionArray objectAtIndex:questionAtm] objectAtIndex:2] intValue], questionAtm);
    
    
    if ([[[answersArray objectAtIndex:questionAtm] objectAtIndex:1] intValue] == 1) {
        correctString = [NSString stringWithFormat:@"%i", [[[answersArray objectAtIndex:questionAtm] objectAtIndex:0] intValue]];
    }
    else if ([[[answersArray objectAtIndex:questionAtm] objectAtIndex:0] intValue] == 0) {
        correctString = @"0";
    }
    else {
        correctString = [NSString stringWithFormat:@"%i / %i", [[[answersArray objectAtIndex:questionAtm] objectAtIndex:0] intValue], [[[answersArray objectAtIndex:questionAtm] objectAtIndex:1] intValue]];
    }
    
    
    if ([[[questionArray objectAtIndex:questionAtm] objectAtIndex:4] intValue] == 1) {
        operationLabel.text = @"+";
    }
    else if ([[[questionArray objectAtIndex:questionAtm] objectAtIndex:4] intValue] == 2) {
        operationLabel.text = @"-";
    }
    else if ([[[questionArray objectAtIndex:questionAtm] objectAtIndex:4] intValue] == 3) {
        operationLabel.text = @"/";
    }
    else if ([[[questionArray objectAtIndex:questionAtm] objectAtIndex:4] intValue] == 4) {
        operationLabel.text = @"*";
    }
    
    [self updateButtonsWithCorrectString:correctString];
    NSLog(@"rätt är : %@", correctString);
    questionAtm++;
    
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

-(void)buttonClicked:(int)buttonNumber {
    if ([self checkIfCorrect:buttonNumber]) {
        correctAnswers++;
        NSLog(@"Rätt!");
    }
    else {
        NSLog(@"Fel!");
    }
    
    correctAnswersLabel.text = [NSString stringWithFormat:@"%i/%i", correctAnswers, questionAtm];
    
    if (questionAtm == 10) {
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
        }
        [self performSegueWithIdentifier:@"ToResult" sender:self];
    }
    else {
        [self presentNextQuestion];
    }
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
        [[questionArray objectAtIndex:1] removeAllObjects];
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
    [self buttonClicked:0];
}

- (IBAction)buttonTwo:(id)sender {
    [self buttonClicked:1];
}

- (IBAction)buttonThree:(id)sender {
    [self buttonClicked:2];
}

- (IBAction)buttonFour:(id)sender {
    [self buttonClicked:3];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ToResult"]) {
        MathResultsViewController *rvc = [segue destinationViewController];
        rvc.results = correctAnswers;
        rvc.difficulty = difficulty;
        rvc.operation = operation;
        rvc.finalTime = finalTime;
        rvc.gamemode = gameMode;
    }
}

@end
