//
//  NatureDetailViewController.m
//  Projektarbete_v1_2
//
//  Created by Jonas Dahl on 2012-10-03.
//
//

#import "NatureDetailViewController.h"
#import "Flurry.h"

@interface NatureDetailViewController ()

@end

@implementation NatureDetailViewController

@synthesize categoryID, subject, category, subjectLabel, questionLabel, buttonOne, buttonTwo, buttonThree, buttonFour, startCountdownTimer, countdownLabel, darkView, startCountdownDate, startCountdown, questions, questionAtm, appDelegate, correctAnswers, correctAnswersNumber, testStartedDate, start_date, timer, time_passed, countdownCounter, start_countdown_date, countdownTimer, progressBar, lastSentErrorReport;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    if (questionAtm > 0) {
        time_passed += [[NSDate date] timeIntervalSinceDate:start_date];
        
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
    subjectLabel.text = timeString;
}

- (void)countdownTimerMethod
{
    [self setCountdownCounter:20-fabs([start_countdown_date timeIntervalSinceNow])];
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:countdownCounter];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm:ss.S"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    NSString *timeString=[dateFormatter stringFromDate:timerDate];
    subjectLabel.text = timeString;
    
    [progressBar setProgress:(20-countdownCounter)/20 animated:YES];
    
    if (countdownCounter <= 0) {
        [self setCountdownCounter:0];
        subjectLabel.text = @"00:00.0";
        [self buttonPressed:5];
    }
    
}

- (void)viewDidLoad {
    
    NSDictionary *eventParams =
    [NSDictionary dictionaryWithObjectsAndKeys:
     subject, @"Subject",
     [category objectAtIndex:0], @"CategoryName",
     [category objectAtIndex:1], @"CategoryID",
     nil];
    
    [Flurry logEvent:@"Test_started" withParameters:eventParams];
    [super viewDidLoad];
    
    questionAtm = 0;
    correctAnswersNumber = 0;
    testStartedDate = [NSDate date];
    
    buttonOne.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    buttonTwo.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    buttonThree.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    buttonFour.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    
    buttonOne.titleLabel.textAlignment = UITextAlignmentCenter;
    buttonTwo.titleLabel.textAlignment = UITextAlignmentCenter;
    buttonThree.titleLabel.textAlignment = UITextAlignmentCenter;
    buttonFour.titleLabel.textAlignment = UITextAlignmentCenter;
    
    [buttonOne setTitle:@"" forState:UIControlStateNormal];
    [buttonTwo setTitle:@"" forState:UIControlStateNormal];
    [buttonThree setTitle:@"" forState:UIControlStateNormal];
    [buttonFour setTitle:@"" forState:UIControlStateNormal];
    
    [buttonOne setBackgroundImage:[UIImage imageNamed:@"white.png"] forState:UIControlStateHighlighted];
    [buttonTwo setBackgroundImage:[UIImage imageNamed:@"white.png"] forState:UIControlStateHighlighted];
    [buttonThree setBackgroundImage:[UIImage imageNamed:@"white.png"] forState:UIControlStateHighlighted];
    [buttonFour setBackgroundImage:[UIImage imageNamed:@"white.png"] forState:UIControlStateHighlighted];
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithObjects:buttonOne, buttonTwo, buttonThree, buttonFour, nil];
    for (int i = 0; i < 4; i++) {
        [[buttons objectAtIndex:i] setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
        [[buttons objectAtIndex:i] setTitleColor:[UIColor brownColor] forState:UIControlStateHighlighted];
    }
    
    subjectLabel.text = [NSString stringWithFormat:@"00:20.0"];
    correctAnswers.text = [NSString stringWithFormat:@"0/0"];
    
    questionLabel.text = @"";
    
    [progressBar setProgress:0];
    
    //Räkna ner 3, 2, 1
    [darkView setHidden:NO];
    startCountdownDate = [NSDate date];
    startCountdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f/10.0f
                                                           target:self
                                                         selector:@selector(startCountdownMethod)
                                                         userInfo:nil
                                                          repeats:YES];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    int iteration;
    NSMutableArray *noId;
    if (categoryID > 0) {
        NSLog(@"catID:%i", categoryID);
        category = [[NSMutableArray alloc] init];
        category = [appDelegate getCategoryWithID:categoryID];
        NSLog(@"catID2:%i", categoryID);
        
        //Ta fram tio frågor i en array
        noId = [[NSMutableArray alloc] init];
        questions = [[NSMutableArray alloc] init];
        [noId addObject:[NSNumber numberWithInt:-1]];
        iteration = [appDelegate numbersOfQuestionsInCategory:categoryID];
        if (iteration > 10) {
            iteration = 10;
        }
    }
    else {
        NSLog(@"catID3:%i", categoryID);
        NSLog(@"catID4:%i", categoryID);
        
        //Ta fram tio frågor i en array
        noId = [[NSMutableArray alloc] init];
        questions = [[NSMutableArray alloc] init];
        [noId addObject:[NSNumber numberWithInt:-1]];
        iteration = 10;
    }
    
    
    
    for (int i = 0; i<iteration; i++) {
        NSLog(@"i:%i", i);
        NSMutableArray *question;
        if (categoryID > 0)
            question = [appDelegate getQuestionInCategory:categoryID withOutIds:noId];
        else {
            question = [appDelegate getQuestionInMainCategory:subject withOutIds:noId];
        }
        if (question != nil) {
            [noId addObject:[question objectAtIndex:1]];
            [questions addObject:question];
        }
    }
}

- (void)presentNextQuestion {
    if (questionAtm == 10) {
        [countdownTimer invalidate];
        countdownTimer = nil;
        NSLog(@"hit");
        [self performSegueWithIdentifier:@"ToResult" sender:self];
    }
    else {
        NSLog(@"Presenting...");
        [countdownTimer invalidate];
        countdownTimer = nil;
        
        start_countdown_date = [NSDate date];
        countdownCounter = 20;
        countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f/20.0f
                                                          target:self
                                                        selector:@selector(countdownTimerMethod)
                                                        userInfo:nil
                                                         repeats:YES];
        
        BOOL error = NO;
        NSMutableArray *question;
        if (questionAtm >= [questions count])
            error = YES;
        else
            question = [questions objectAtIndex:questionAtm];
        
        correctAnswers.text = [NSString stringWithFormat:@"%i/%i", correctAnswersNumber, questionAtm];
        
        if (!error && question != nil) {
            questionLabel.text = [question objectAtIndex:0];
            
            [buttonOne setTitle:[[[question objectAtIndex:2] objectAtIndex:0] objectAtIndex:0] forState:UIControlStateNormal];
            [buttonTwo setTitle:[[[question objectAtIndex:2] objectAtIndex:1] objectAtIndex:0] forState:UIControlStateNormal];
            [buttonThree setTitle:[[[question objectAtIndex:2] objectAtIndex:2] objectAtIndex:0] forState:UIControlStateNormal];
            [buttonFour setTitle:[[[question objectAtIndex:2] objectAtIndex:3] objectAtIndex:0] forState:UIControlStateNormal];
        }
        else {
            questionLabel.text = @"There are no more questions in this category. :(. To complain, please contact dahl.montalvo@gmail.com using the About tab from the Main Menu.";
            [buttonOne setHidden:YES];
            [buttonTwo setHidden:YES];
            [buttonThree setHidden:YES];
            [buttonFour setHidden:YES];
        }
        NSLog(@"Question %i", questionAtm);
        NSLog(@"%@", [questions objectAtIndex:questionAtm]);
        questionAtm++;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return 0;
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
    
    countdownLabel.text = [NSString stringWithFormat:@"%i", val];
    if (startCountdown <= 0) {
        [darkView setHidden:YES];
        //[darkView removeFromSuperview];
        [startCountdownTimer invalidate];
        startCountdownTimer = nil;
        
        
        //Vi är nu redo att presentera den första frågan
        [self presentNextQuestion];
    }
    
}


- (void)viewDidUnload {
    [self setSubjectLabel:nil];
    [self setQuestionLabel:nil];
    [self setButtonOne:nil];
    [self setButtonTwo:nil];
    [self setButtonThree:nil];
    [self setButtonFour:nil];
    [self setDarkView:nil];
    [self setCountdownLabel:nil];
    [self setPauseButton:nil];
    [self setCorrectAnswers:nil];
    [self setProgressBar:nil];
    [super viewDidUnload];
}
- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)pauseButtonPressed:(id)sender {
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Menu" delegate:self cancelButtonTitle:@"Resume" destructiveButtonTitle:@"Exit" otherButtonTitles:@"Restart Quiz", @"Report Question", nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[popupQuery showInView:[UIApplication sharedApplication].keyWindow];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
	if (buttonIndex == 0) {
        //Döda klockan
        [countdownTimer invalidate];
        countdownTimer = nil;
        if ([self.navigationController.viewControllers objectAtIndex:1] != nil) {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }
		
	} else if (buttonIndex == 1) {
        //Döda klockan
        [countdownTimer invalidate];
        countdownTimer = nil;
        [self viewDidLoad];
        
	} else if (buttonIndex == 2) {
		[self report];
    } 
}
- (IBAction)buttonOne:(id)sender {
    [self buttonPressed:1];
}

- (IBAction)buttonTwo:(id)sender {
    [self buttonPressed:2];
}

- (IBAction)buttonThree:(id)sender {
    [self buttonPressed:3];
}

- (IBAction)buttonFour:(id)sender {
    [self buttonPressed:4];
}

-(void)report {
    if (lastSentErrorReport < questionAtm) {
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Report Error"
                                                          message:@"Are u sure that u want to report this question as incorrect?"
                                                         delegate:self
                                                cancelButtonTitle:@"No"
                                                otherButtonTitles:@"Yes",nil];
        [message show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
	NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
	if([title isEqualToString:@"Yes"]) {
        
        int qID = [[[questions objectAtIndex:questionAtm] objectAtIndex:1] intValue];
        int token = qID*3+253;
        NSString *postString = [NSString stringWithFormat:@"qid=%i&token=%i", qID, token];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://simplescience.dahlmontalvo.com/report.php"]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:[NSString stringWithFormat:@"%d", [postString length]] forHTTPHeaderField:@"Content-length"];
        [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        conn = nil;
        lastSentErrorReport = questionAtm;
    }
}

- (IBAction)reportButtonPressed:(id)sender {
    [self report];
}

- (void)noBG {
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithObjects:buttonOne, buttonTwo, buttonThree, buttonFour, nil];
    for (int i = 0; i < 4; i++) {
        [[buttons objectAtIndex:i] setBackgroundImage:[UIImage imageNamed:@"white.png"] forState:UIControlStateNormal];
        [[buttons objectAtIndex:i] setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
        [[buttons objectAtIndex:i] setBackgroundImage:[UIImage imageNamed:@"white.png"] forState:UIControlStateHighlighted];
        [[buttons objectAtIndex:i] setTitleColor:[UIColor brownColor] forState:UIControlStateHighlighted];
        [[buttons objectAtIndex:i] setEnabled:YES];
    }
}

-(void)buttonPressed:(int)buttonIndex {
    
    [self setCountdownCounter:0];
    [countdownTimer invalidate];
    countdownTimer = nil;
    
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithObjects:buttonOne, buttonTwo, buttonThree, buttonFour, nil];
    for (int i = 0; i < 4; i++) {
        [[buttons objectAtIndex:i] setEnabled:NO];
    }
    
    if (buttonIndex < 5 && buttonIndex > 0) {
        [[buttons objectAtIndex:buttonIndex-1] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if ([[[[[questions objectAtIndex:questionAtm-1] objectAtIndex:2] objectAtIndex:buttonIndex-1] objectAtIndex:2] intValue] == 1) {
            correctAnswersNumber++;
            [[buttons objectAtIndex:buttonIndex-1] setBackgroundImage:[UIImage imageNamed:@"green.png"] forState:UIControlStateNormal];
        }
        else {
            [[buttons objectAtIndex:buttonIndex-1] setBackgroundImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];
        }
    }
    [self performSelector:@selector(noBG) withObject:nil afterDelay:.5];
    [self performSelector:@selector(presentNextQuestion) withObject:nil afterDelay:.5];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ToResult"]) {
        NatureResultsViewController *rvc = [segue destinationViewController];
        rvc.score = correctAnswersNumber;
        rvc.testStartedDate = testStartedDate;
        rvc.categoryId = categoryID;
        rvc.subject = subject;
    }
}

@end
