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
@synthesize startCountdownLabel;
@synthesize darkView;
@synthesize questionLabel;
@synthesize firstLineLabel;
@synthesize secondLineLabel;
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
@synthesize startCountdownTimer;
@synthesize startCountdown;
@synthesize testStarted;
@synthesize startCountdownDate;
@synthesize startCountdownCounter;

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

- (void)startCountdownMethod
{
    [self setStartCountdown:3-fabs([startCountdownDate timeIntervalSinceNow])];
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:startCountdown];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"s"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    NSString *timeString=[dateFormatter stringFromDate:timerDate];
    
    int val = [timeString intValue]+1;
    
    startCountdownLabel.text = [NSString stringWithFormat:@"%i", val];
    if (startCountdown <= 0) {
        [darkView setHidden:YES];
        //[darkView removeFromSuperview];
        [startCountdownTimer invalidate];
        startCountdownTimer = nil;
        
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
        if ([operation isEqualToString:@"Fraction"]) {
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
        }
        else if ([operation isEqualToString:@"Equations"]) {
            questionArray = [[NSMutableArray alloc] init];
            answersArray = [[NSMutableArray alloc] init];
            correctAnswers = 0;
            //Skapa frågor
            
            for (int i = 0; i < 10; i++) {
                int a = (arc4random() % 50)/(6-difficulty)+1;
                int b = (arc4random() % 50)/(6-difficulty)+1;
                int c = (arc4random() % 50)/(6-difficulty)+1;
                NSString *question;
                int x;
                bool leaveLoop;
                
                //fan va bra du har gjort det här.
                
                switch (difficulty) {
                    case 1:
                        question = [NSString stringWithFormat:@"%i + x = %i", a, b];
                        x = b-a;
                        break;
                    case 2:
                        b=b/2+1;
                        a*=3;
                        c*=5;
                        leaveLoop = NO;
                        while (leaveLoop == NO) {
                            if ((c-a)%b != 0) {
                                a++;
                            }
                            else if (c-a==0) {
                                a++;
                            }
                            else leaveLoop = YES;
                        }
                        if (a > c) { int temp = a; a=c; c=temp; }
                        question = [NSString stringWithFormat:@"%i + %ix = %i", a, b, c];
                        x = (c-a)/b;
                        break;
                    case 3:
                        b=b/2+1;
                        a*=3;
                        c*=5;
                        leaveLoop = NO;
                        while (leaveLoop == NO) {
                            if ((a-c)%(b) != 0) {
                                a++;
                            }
                            else if (c+a==0) {
                                a++;
                            }
                            else leaveLoop = YES;
                        }
                        if (a < c) { int temp = a; a=c; c=temp; }
                        question = [NSString stringWithFormat:@"%i - %ix = %i", a, b, c];
                        x = (a-c)/(b);
                        break;
                    case 4:
                        leaveLoop = NO;
                        while (leaveLoop == NO) {
                            if (a+b==0) {
                                a++;
                            }
                            else leaveLoop = YES;
                        }
                        c=(a+b)*(arc4random()%10-5);
                        question = [NSString stringWithFormat:@"%ix + %ix = %i", a, b, c];
                        x = c/(a+b);
                        break;
                    case 5:
                        leaveLoop = NO;
                        while (leaveLoop == NO) {
                            if (a-b==0) {
                                a++;
                            }
                            else leaveLoop = YES;
                        }
                        c=(a+b)*(arc4random()%16-8);
                        question = [NSString stringWithFormat:@"%ix - %ix = %i", a, b, c];
                        x = c/(a-b);
                        break;
                        
                    default:
                        break;
                }
                
                [questionArray insertObject:question atIndex:i];
                [answersArray insertObject:[NSNumber numberWithInt:x] atIndex:i];
            }
        }
        else if ([operation isEqualToString:@"Percent"]) {
            questionArray = [[NSMutableArray alloc] init];
            answersArray = [[NSMutableArray alloc] init];
            correctAnswers = 0;
            //Skapa frågor
            
            for (int i = 0; i < 10; i++) {
                int a = (arc4random() % 95);
                a=(a/10)*10;
                int b = (arc4random() % 500)/(6-difficulty)+5;
                NSString *question;
                int x;
                int typeOfQuestion = arc4random() % 2+1;
                NSLog(@"%i", typeOfQuestion);
                bool leave;
                NSString *unit;
                //Fem olika frågtyper 1-5.
                /*
                 1: 5% av 100 =
                 2: Hur många procent motsvarar 5/20?
                 */
                
                switch (typeOfQuestion) {
                    case 1:
                        // 5% av 100 =
                        leave = NO;
                        while (leave == NO) {
                            float f = ((float)a/100.0)*(float)b;
                            if (f-(int)f == 0)
                                leave = YES;
                            else {
                                b++;
                            }
                        }
                        question = [NSString stringWithFormat:@"%i%% of %i = ?", a, b];
                        x = (int)(((float)a/100.0)*b);
                        unit = @"";
                        break;
                        
                    case 2:
                        // Mur många procent motsvarar 5/20?
                        if (difficulty < 4) {
                            b=(b/10)*10;
                        }
                        
                        if (b==0) {
                            b = 1;
                        }
                        
                        question = [NSString stringWithFormat:@"%i of %i = ?", a, b];
                        x = 100*a/b;
                        unit = @" %";
                        break;
                        
                    default:
                        break;
                }
                
                [questionArray insertObject:[[NSMutableArray alloc] initWithObjects:question, unit, nil] atIndex:i];
                [answersArray insertObject:[NSNumber numberWithInt:x] atIndex:i];
            }
        }
        
        [self presentNextQuestion];
    }
    
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

-(void)updateButtonsWithCorrectString:(NSString *)correct andCorrectValue:(float)correctVal andUnit:(NSString*)unit {
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithObjects:buttonOne, buttonTwo, buttonThree, buttonFour, nil];
    //Vilken ska vara rätt? 0-3
    correctButton = arc4random() % 3;
    UIButton *button;
    NSMutableArray *earlierInTheListValues = [[NSMutableArray alloc] init];
    for (int i = 0; i < 4; i++) {
        button = [buttons objectAtIndex:i];
        if (i == correctButton) {
            [button setTitle:[NSString stringWithFormat:@"%@%@", correct, unit] forState:UIControlStateNormal];
        }
        else {
            if ([operation isEqualToString:@"Fraction"]) {
                bool leave = NO;
                int first = 1;
                int second = 1;
                while (leave == NO) {
                    first = arc4random() % 9 + 1;
                    second = arc4random() % 9 + 1;
                    
                    float quota = (float)first/(float)second;
                    if (quota != correctVal) {
                        leave = YES;
                    }
                }
                
                [button setTitle:[NSString stringWithFormat:@"%i / %i", first, second] forState:UIControlStateNormal];
            }
            else if ([operation isEqualToString:@"Equations"]) {
                bool leave = NO;
                int a = 1;
                while (leave == NO) {
                    a = arc4random() % 30 - 15;
                    if (a != correctVal)
                        leave = YES;
                }
                [button setTitle:[NSString stringWithFormat:@"x = %i", a] forState:UIControlStateNormal];
            }
            else if ([operation isEqualToString:@"Percent"]) {
                bool leave = NO;
                int a;
                while (leave == NO) {
                    a = arc4random() % (int)(correctVal*2+4);
                    bool alreadyThere = NO;
                    for (int q = 0; q < [earlierInTheListValues count]; q++) {
                        NSLog(@"Letar om %i finns...", a);
                        if ([[earlierInTheListValues objectAtIndex:q] intValue] == a) {
                            alreadyThere = YES;
                            NSLog(@"...och hittade");
                        }
                    }
                    if (a != correctVal && alreadyThere == NO)
                        leave = YES;
                }
                [earlierInTheListValues addObject:[NSNumber numberWithInt:a]];
                [button setTitle:[NSString stringWithFormat:@"%i%@", a, unit] forState:UIControlStateNormal];
            }
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
        
    questionAtm = 0;
    [darkView setHidden:NO];
    [questionArray removeAllObjects];
    [answersArray removeAllObjects];
    countdownLabel.text = @"00:00.0";
    correctAnswersLabel.text = @"0/0";
    denominatorOneLabel.text = @"";
    denominatorTwoLabel.text = @"";
    numeratorOneLabel.text = @"";
    numeratorTwoLabel.text = @"";
    questionLabel.text = @"";
    
    if (![operation isEqualToString:@"Fraction"]) {
        operationLabel.text = @"";
        firstLineLabel.text = @"";
        secondLineLabel.text = @"";
    }
    testStarted = NO;
    
    startCountdownDate = [NSDate date];
    startCountdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f/10.0f
                                                           target:self
                                                         selector:@selector(startCountdownMethod)
                                                         userInfo:nil
                                                          repeats:YES];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)presentNextQuestion {
    
    testStarted = YES;
    
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
    if ([operation isEqualToString:@"Fraction"]) {
        numeratorOneLabel.text = [NSString stringWithFormat:@"%i", [[[questionArray objectAtIndex:questionAtm] objectAtIndex:0] intValue]];
        numeratorTwoLabel.text = [NSString stringWithFormat:@"%i", [[[questionArray objectAtIndex:questionAtm] objectAtIndex:1] intValue]];
        denominatorOneLabel.text = [NSString stringWithFormat:@"%i", [[[questionArray objectAtIndex:questionAtm] objectAtIndex:2] intValue]];
        denominatorTwoLabel.text = [NSString stringWithFormat:@"%i", [[[questionArray objectAtIndex:questionAtm] objectAtIndex:3] intValue]];
        NSLog(@"%i, %i, 2", [[[questionArray objectAtIndex:questionAtm] objectAtIndex:2] intValue], questionAtm);
        
        float correctVal = 0.0;
        
        if ([[[answersArray objectAtIndex:questionAtm] objectAtIndex:1] intValue] == 1) {
            correctString = [NSString stringWithFormat:@"%i", [[[answersArray objectAtIndex:questionAtm] objectAtIndex:0] intValue]];
            correctVal = (float)[[[answersArray objectAtIndex:questionAtm] objectAtIndex:0] intValue];
        }
        else if ([[[answersArray objectAtIndex:questionAtm] objectAtIndex:0] intValue] == 0) {
            correctString = @"0";
            correctVal = 0;
        }
        else {
            correctString = [NSString stringWithFormat:@"%i / %i", [[[answersArray objectAtIndex:questionAtm] objectAtIndex:0] intValue], [[[answersArray objectAtIndex:questionAtm] objectAtIndex:1] intValue]];
            correctVal = (float)[[[answersArray objectAtIndex:questionAtm] objectAtIndex:0] intValue]/(float)[[[answersArray objectAtIndex:questionAtm] objectAtIndex:1] intValue];
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
        
        [self updateButtonsWithCorrectString:correctString andCorrectValue:correctVal andUnit:@""];
    }
    else if ([operation isEqualToString:@"Equations"]) {
        questionLabel.text = [questionArray objectAtIndex:questionAtm];
        NSString *cs = [NSString stringWithFormat:@"x = %i", [[answersArray objectAtIndex:questionAtm] intValue]];
        [self updateButtonsWithCorrectString:cs andCorrectValue:[[answersArray objectAtIndex:questionAtm] intValue] andUnit:@""];
        correctString = cs;
    }
    else if ([operation isEqualToString:@"Percent"]) {
        questionLabel.text = [[questionArray objectAtIndex:questionAtm] objectAtIndex:0];
        NSString *cs = [NSString stringWithFormat:@"%i", [[answersArray objectAtIndex:questionAtm] intValue]];
        [self updateButtonsWithCorrectString:cs andCorrectValue:[[answersArray objectAtIndex:questionAtm] intValue] andUnit:[[questionArray objectAtIndex:questionAtm] objectAtIndex:1]];
        correctString = [NSString stringWithFormat:@"%@%@", cs, [[questionArray objectAtIndex:questionAtm] objectAtIndex:1]];
    }
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
    [self setStartCountdownLabel:nil];
    [self setDarkView:nil];
    [self setQuestionLabel:nil];
    [self setFirstLineLabel:nil];
    [self setSecondLineLabel:nil];
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
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
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
        [questionArray removeAllObjects];
        correctAnswersLabel.text = @"";
        correctAnswers = 0;
        
        [countdownTimer invalidate];
        countdownTimer = nil;
        [timer invalidate];
        timer = nil;
        cancelCountdown = YES;
        countdownLabel.text = @"0";
        [self onReset];
        [self viewDidLoad];
        
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
