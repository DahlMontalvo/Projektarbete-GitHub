//
//  MathExerciseViewController.m
//  Simple Science
//
//  Copyright (c) 2013 Jonas Dahl & Philip Montalvo. All rights reserved.
//

#import "MathExerciseViewController.h"

@implementation MathExerciseViewController

@synthesize operation, difficulty, start_countdown_date, startCountdownLabel, darkView, quizArray, questionAtm, answer, countdownLabel, correctAnswers, correctAnswersLabel, numberLabel, exerciseLabel, nextButton, answerFromUser, navItem, gameMode, pauseButton, countdownCounter, cancelCountdown, finalTime, interval, decimalSignInserted, keyboard0, keyboardback, keyboard1, keyboard2, keyboard3, keyboard4, keyboard5, keyboard6, keyboard7, keyboard8, keyboard9, startCountdownTimer, startCountdown, testStarted, startCountdownDate, startCountdownCounter, progressBar;

#pragma mark - Initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

#pragma mark - Timer
- (void)timer {
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

-(void)onTimerStart {
    //NÄR STOPPURET STARTAS FÖRSTA GÅNGEN
    time_passed = 0;
    
    //Startdatum
    start_date = [NSDate date];
    
    //Startar en timer som uppdateras tio gånger i sekunden
    timer = [NSTimer timerWithTimeInterval:1.0/10.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
}

-(void)onPause {
    //Räkna ut passerad tid
    if (testStarted == YES) {
          time_passed += [[NSDate date] timeIntervalSinceDate: start_date];
        
    }
    //Stanna klockan
    [timer invalidate];
}

-(void)onUnpause {
    //Nytt startdatum
    start_date = [NSDate date];
    
    //Starta timer för att uppdatera UIt
    timer = [NSTimer timerWithTimeInterval:1.0/10.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
}

-(void)onReset {
    [timer invalidate];
    time_passed = 0;
    start_date = nil;
}

-(void)onTimer {
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

- (void)countdownTimer {
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
    [progressBar setProgress:((5+5*difficulty)-countdownCounter)/(5+5*difficulty) animated:YES];
}

- (void)startCountdownMethod {
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
        [self nextButtonPressed];
    }
    
}

#pragma mark - View management
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSMutableArray *) newQuizArrayFromCountingOperation:(NSString *)localOperation andDifficulty:(int)localDifficulty numberOfQuestions:(int)num {
    
    NSMutableArray *questionsArray = [[NSMutableArray alloc] init];
    NSMutableArray *answersArray = [[NSMutableArray alloc] init];
    NSMutableArray *userAnswersArray = [[NSMutableArray alloc] init];
    NSMutableArray *localQuizArray = [[NSMutableArray alloc] initWithObjects:questionsArray, answersArray, userAnswersArray, nil];
    //Frågor placeras i quizArray[0]
    
    //Lite minnesplatser
    int number1; 
    int number2;
    int number3;
    int localAnswer;
    NSString *text;
    
    //En loop för varje fråga
    for (int i = 0; i < num; i++) {
        switch (localDifficulty) {
            case 1:
                number1 = (arc4random() % 10);
                number2 = (arc4random() % 10);
                number3 = (arc4random() % 10);
                break;
                
            case 2:
                number1 = arc4random() % 10 + 10;
                number2 = arc4random() % 10 + 10;
                number3 = arc4random() % 10 + 10;
                break;
                
            case 3:
                number1 = arc4random() % 25 + 5;
                number2 = arc4random() % 25 + 5;
                number3 = arc4random() % 25 + 5;
                break;
                
            case 4:
                number1 = arc4random() % 25+10;
                number2 = arc4random() % 25+10;
                number3 = arc4random() % 25+10;
                break;
                
            case 5:
                number1 = arc4random() % 50 + 10;
                number2 = arc4random() % 50 + 10;
                number3 = arc4random() % 50 + 10;
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
            if (difficulty > 3) {
                localAnswer = number1+number2+number3;
                if (arc4random() % 2 == 1) {
                    text = [NSString stringWithFormat:@"%i + %i + %i", number1, number2, number3];
                }
                else {
                    text = [NSString stringWithFormat:@"%i + (%i + %i)", number1, number2, number3];
                }
            }
            else {
                localAnswer = number1+number2;
                text = [NSString stringWithFormat:@"%i + %i", number1, number2];
            }
        }
        else if ([localOperation isEqualToString:@"Subtraction"]) {
            if (difficulty > 3) {
                int slump = arc4random() % 4;
                if (slump == 4) {
                    bool continueLoop = YES;
                    while(continueLoop) {
                        if (number1 >= (number2-number3)) {
                            continueLoop = NO;
                        }
                        else {
                            number2+=(arc4random()%20);
                        }
                    }
                    text = [NSString stringWithFormat:@"%i - (%i - %i)", number1, number2, number3];
                    localAnswer = number1-(number2-number3);
                }
                else if (slump == 3) {
                    bool continueLoop = YES;
                    while(continueLoop) {
                        if (number1-number2 >= number3) {
                            continueLoop = NO;
                        }
                        else {
                            number1+=(arc4random()%20);
                        }
                    }
                    text = [NSString stringWithFormat:@"(%i - %i) - %i", number1, number2, number3];
                    localAnswer = (number1-number2)-number3;
                }
                else if (slump == 2) {
                    bool continueLoop = YES;
                    while(continueLoop) {
                        if ((number2-number3)*-1 <= number1) {
                            continueLoop = NO;
                        }
                        else {
                            number1+=(arc4random()%20);
                        }
                    }
                    text = [NSString stringWithFormat:@"%i + (%i - %i)", number1, number2, number3];
                    localAnswer = number1+(number2-number3);
                }
                else {
                    bool continueLoop = YES;
                    while(continueLoop) {
                        if (number1 >= (number2+number3)) {
                            continueLoop = NO;
                        }
                        else {
                            number1+=(arc4random()%20);
                        }
                    }
                    text = [NSString stringWithFormat:@"%i - (%i + %i)", number1, number2, number3];
                    localAnswer = number1-(number2+number3);
                }
            }
            else {
                if (number1-number2 < 5) number1+=arc4random() % 10 + 5;
                localAnswer = number1-number2;
                text = [NSString stringWithFormat:@"%i - %i", number1, number2];
            } 
        } 
        else if ([localOperation isEqualToString:@"Division"]) {
            number1*=difficulty+1;
            number2*=1.2;
            number3*=(difficulty+1)/3;
            number2/=2;
            
            number2++;
            if (number1%number2 != 0) {
                number1 = number1 - (number1%number2);
            }
            if (number1 < 0) {
                number1 = 0;
            }
            
            if (difficulty > 3) {
                number1*=0.7;
                number2*=0.7;
                number3*=0.7;
                number2/=2;
                
                number2++;
                int slump = arc4random() % 6;
                
                if (slump == 6) {
                    if (number1%number2 != 0) {
                        number1 = number1 - number1%number2;
                    }
                    localAnswer = (float) number1 / (float) number2 + number3;
                    text = [NSString stringWithFormat:@"%i / %i + %i", number1, number2, number3];
                    
                }
                else if (slump == 5) {
                    if (number1%number2 != 0) {
                        number1 = number1 - number1%number2;
                    }
                    bool continueLoop = YES;
                    while(continueLoop) {
                        if ((float) number1 / (float) number2 >= number3) {
                            if (number1/number2 == number3) {
                                number3 = arc4random()%10;
                            }
                            else {
                                continueLoop = NO;
                            }
                        }
                        else {
                            number3--;
                        }
                    }
                    localAnswer = (float) number1 / (float) number2 - number3;
                    text = [NSString stringWithFormat:@"%i / %i - %i", number1, number2, number3];
                    
                }
                else if (slump == 4) {
                    number3/=5;
                    if (number1%(number2+number3) != 0) {
                        number1 = number1 - (number1%(number2+number3));
                    }
                    localAnswer = (float) number1 / (float) (number2+number3);
                    text = [NSString stringWithFormat:@"%i / (%i + %i)", number1, number2, number3];
                    
                }
                else if (slump == 3) {
                    number3/=5;
                    if ((number1+number3)%number2 != 0) {
                        number1-=((number1+number3)%number2);
                    }
                    localAnswer = (float) (number1+number3) / (float) number2;
                    text = [NSString stringWithFormat:@"(%i + %i) / %i", number1, number3, number2];
                    
                }
                else if (slump == 2) {
                    number3/=5;
                    if ((number1-number3)%number2 != 0) {
                        number1-=((number1-number3)%number2);
                    }
                    localAnswer = (float) (number1-number3) / (float) number2;
                    text = [NSString stringWithFormat:@"(%i - %i) / %i", number1, number3, number2];
                    
                }
                else {
                    number3/=5;
                    if (number3 > number2) {
                        int temp = number3;
                        number3 = number2;
                        number2 = temp;
                    }
                    if ((number2-number3) == 0) {
                        number2++;
                    }
                    if (number1%(number2-number3) != 0) {
                        number1-=number1%(number2-number3);
                    }
                    localAnswer = (float) number1 / (float) (number2-number3);
                    text = [NSString stringWithFormat:@"%i / (%i - %i)", number1, number2, number3];
                }
                    
            }
            else {
                
                localAnswer = (float) number1 / (float) number2;
                text = [NSString stringWithFormat:@"%i / %i", number1, number2];
            }
            
            
        } 
        else if ([localOperation isEqualToString:@"Multiplication"]) {
            if (difficulty > 3) {
                number1/=difficulty;
                number2/=difficulty;
                number3/=difficulty;
                int slump = arc4random() % 5;
                if (slump == 5 && difficulty == 5) {
                    
                    int number4 = arc4random() % 25 + 1;
                    text = [NSString stringWithFormat:@"(%i + %i) * (%i + %i)", number1, number2, number3, number4];
                    localAnswer = (number1+number2)*(number3+number4);
                    
                }
                else if (slump == 4 && difficulty == 5) {
                    
                    int number4 = arc4random() % 25 + 1;
                    
                    bool continueLoop = YES;
                    while(continueLoop) {
                        if (number3 >= number4) {
                            continueLoop = NO;
                        }
                        else {
                            number3+=(arc4random()%20);
                        }
                    }
                    
                    text = [NSString stringWithFormat:@"(%i + %i) * (%i - %i)", number1, number2, number3, number4];
                    localAnswer = (number1+number2)*(number3-number4);
                    
                }
                else if (slump > 3) {
                    
                    text = [NSString stringWithFormat:@"%i * (%i + %i)", number1, number2, number3];
                    localAnswer = number1*(number2+number3);
                    
                }
                else if (slump == 3) {
                    
                    text = [NSString stringWithFormat:@"%i(%i + %i)", number1, number2, number3];
                    localAnswer = number1*(number2+number3);
                    
                }
                else if (slump == 2) {
                    bool continueLoop = YES;
                    while(continueLoop) {
                        if (number2 >= number3) {
                            continueLoop = NO;
                        }
                        else {
                            number2+=(arc4random()%20);
                        }
                    }
                    text = [NSString stringWithFormat:@"%i(%i - %i)", number1, number2, number3];
                    localAnswer = number1*(number2-number3);
                }
                else {
                    bool continueLoop = YES;
                    while(continueLoop) {
                        if (number2 >= number3) {
                            continueLoop = NO;
                        }
                        else {
                            number2+=(arc4random()%20);
                        }
                    }
                    text = [NSString stringWithFormat:@"%i * (%i - %i)", number1, number2, number3];
                    localAnswer = number1*(number2-number3);
                }
            }
            else {
                if (difficulty == 3) {
                    number1*=1.75;
                    number2*=1.75;
                    number3*=1.75;
                }
                number1/=difficulty;
                number2/=difficulty;
                number3/=difficulty;
                localAnswer = number1*number2;
                text = [NSString stringWithFormat:@"%i * %i", number1, number2];
            }
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [darkView setHidden:NO];
    [quizArray removeAllObjects];
    
    correctAnswersLabel.text = @"0/0";
    
    [keyboard1 setEnabled:NO];
    [keyboard2 setEnabled:NO];
    [keyboard3 setEnabled:NO];
    [keyboard4 setEnabled:NO];
    [keyboard5 setEnabled:NO];
    [keyboard6 setEnabled:NO];
    [keyboard7 setEnabled:NO];
    [keyboard8 setEnabled:NO];
    [keyboard9 setEnabled:NO];
    [keyboard0 setEnabled:NO];
    [keyboardback setEnabled:NO];
    
    testStarted = NO;
    
    cancelCountdown = NO;
    correctAnswers = 0;
    questionAtm = 0;
    
    //SAKER FÖR ATT STÄDA UPP
    navItem.hidesBackButton = YES;
    [navItem setTitle:[NSString stringWithFormat:@"%@ in %@ %i",gameMode,operation,difficulty]];

    quizArray = [self newQuizArrayFromCountingOperation:operation andDifficulty:difficulty numberOfQuestions:10];

    if ([gameMode isEqualToString:@"Test"]) {
        //Exit ist för pause
        [pauseButton setTitle:@"Exit" forState:UIControlStateNormal];
        [progressBar setHidden:NO];
    }
    else {
        [progressBar setHidden:YES];
    }
    
    countdownLabel.text = @"00:00.0";

    startCountdownDate = [NSDate date];
    startCountdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f/10.0f
                                                  target:self
                                                selector:@selector(startCountdownMethod)
                                                userInfo:nil
                                                 repeats:YES];
    
    
}

- (void)viewDidUnload {
    [self setCorrectAnswersLabel:nil];
    [self setExerciseLabel:nil];
    [self setAnswerFromUser:nil];
    [self setExerciseLabel:nil];
    [self setNextButton:nil];
    [self setNumberLabel:nil];
    [self setCountdownLabel:nil];
    [self setPauseButton:nil];
    [self setKeyboard1:nil];
    [self setKeyboard2:nil];
    [self setKeyboard3:nil];
    [self setKeyboard4:nil];
    [self setKeyboard5:nil];
    [self setKeyboard6:nil];
    [self setKeyboard7:nil];
    [self setKeyboard8:nil];
    [self setKeyboard9:nil];
    [self setKeyboard0:nil];
    [self setKeyboardback:nil];
    [self setDarkView:nil];
    [self setStartCountdownLabel:nil];
    [self setProgressBar:nil];
    [super viewDidUnload];
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

#pragma mark - Others
-(void)nextButtonPressed {
    decimalSignInserted = NO;
    testStarted = YES;
    questionAtm++;
    [countdownTimer invalidate];
    countdownTimer = nil;
    
    
    //Vid test gäller andra puckar för klockan
    if ([gameMode isEqualToString:@"Test"] && questionAtm < 11) {
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
        if (YES) {
            [keyboard1 setEnabled:YES];
            [keyboard2 setEnabled:YES];
            [keyboard3 setEnabled:YES];
            [keyboard4 setEnabled:YES];
            [keyboard5 setEnabled:YES];
            [keyboard6 setEnabled:YES];
            [keyboard7 setEnabled:YES];
            [keyboard8 setEnabled:YES];
            [keyboard9 setEnabled:YES];
            [keyboard0 setEnabled:YES];
            [keyboardback setEnabled:YES];
        }
        
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
        [nextButton setTitle:@"Skip" forState:UIControlStateNormal];
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
        [nextButton setTitle:@"Skip" forState:UIControlStateNormal];
    }
    if (questionAtm == 11) {
        //Skickar med tiden till nästa view
        
        if ([gameMode isEqualToString:@"Test"]) {
            
            NSDate *currentDate = [NSDate date];
            NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:testDate];
            finalTime = timeInterval;
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
    
    int answerFromUserInt = [answerFromUser.text intValue];
    [[quizArray objectAtIndex:2] insertObject:[NSNumber numberWithInt:answerFromUserInt] atIndex:questionAtm-1];
    if (answerFromUserInt == [[[quizArray objectAtIndex:1] objectAtIndex:questionAtm-1] intValue]) {
        [self nextButtonPressed];
    }
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

- (IBAction)keyboard0:(id)sender {
    [self addNumber:0];
}

- (IBAction)keyboardback:(id)sender {
    NSString *string = [answerFromUser text];
    if ([string hasSuffix:@"."]) {
        decimalSignInserted = NO;
    }
    if ( [string length] > 0)
        string = [string substringToIndex:[string length] - 1];
    answerFromUser.text = string;
}

- (IBAction)nextButton:(id)sender {
    [self nextButtonPressed];
}

-(IBAction)pausePressed:(id)sender {
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Quiz paused" delegate:self cancelButtonTitle:@"Resume" destructiveButtonTitle:@"Exit" otherButtonTitles:@"Restart quiz", nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[popupQuery showInView:[UIApplication sharedApplication].keyWindow];
    
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
	}
    else if (buttonIndex == 1) {
        //Restarta 
        questionAtm = 0;
        [[quizArray objectAtIndex:1] removeAllObjects];
        correctAnswersLabel.text = @"";
        numberLabel.text = @"";
        exerciseLabel.text = @"";
        answerFromUser.text = @"";
        correctAnswers = 0;
        
        [countdownTimer invalidate];
        countdownTimer = nil;
        [timer invalidate];
        timer = nil;
        cancelCountdown = YES;
        countdownLabel.text = @"0";
        [self onReset];
        
        [self viewDidLoad];
    
	}
    else if (buttonIndex == 2) {
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
