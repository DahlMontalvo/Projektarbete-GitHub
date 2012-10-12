//
//  NatureDetailViewController.m
//  Projektarbete_v1_2
//
//  Created by Jonas Dahl on 2012-10-03.
//
//

#import "NatureDetailViewController.h"

@interface NatureDetailViewController ()

@end

@implementation NatureDetailViewController

@synthesize categoryID, subject, category, subjectLabel, questionLabel, buttonOne, buttonTwo, buttonThree, buttonFour, startCountdownTimer, countdownLabel, darkView, startCountdownDate, startCountdown, questions, questionAtm, appDelegate, correctAnswers, correctAnswersNumber;

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
    questionAtm = 0;
    correctAnswersNumber = 0;
    
    //Räkna ner 3, 2, 1
    [darkView setHidden:NO];
    startCountdownDate = [NSDate date];
    startCountdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f/10.0f
                                                           target:self
                                                         selector:@selector(startCountdownMethod)
                                                         userInfo:nil
                                                          repeats:YES];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    category = [[NSMutableArray alloc] init];
    category = [appDelegate getCategoryWithID:categoryID];
    
    subjectLabel.text = [NSString stringWithFormat:@"00:00.0"];
    correctAnswers.text = [NSString stringWithFormat:@"0/0"];
    
    //Ta fram tio frågor i en array
    NSMutableArray *noId = [[NSMutableArray alloc] init];
    questions = [[NSMutableArray alloc] init];
    [noId addObject:[NSNumber numberWithInt:-1]];
    int iteration = [appDelegate numbersOfQuestionsInCategory:categoryID];
    if (iteration > 10) {
        iteration = 10;
    }
    
    for (int i = 0; i<iteration; i++) {
        NSMutableArray *question = [appDelegate getQuestionInCategory:categoryID withOutIds:noId];
        [noId addObject:[question objectAtIndex:1]];
        [questions addObject:question];
    }
    
    //Vi är nu redo att presentera den första frågan
    [self presentNextQuestion];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)presentNextQuestion {
    if (questionAtm == 10) {
        [self performSegueWithIdentifier:@"ToResult" sender:self];
    }
    else {
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
            questionLabel.text = @"You have reached the point of no return. Det finns inte tillräckligt med frågor i denna kategori. Klaga på dahl.montalvo@gmail.com.";
            [buttonOne setHidden:YES];
            [buttonTwo setHidden:YES];
            [buttonThree setHidden:YES];
            [buttonFour setHidden:YES];
        }
        
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
        //[self nextButtonPressed];
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
    [super viewDidUnload];
}
- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)pauseButtonPressed:(id)sender {
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Quiz paused" delegate:self cancelButtonTitle:@"Resume" destructiveButtonTitle:@"Exit" otherButtonTitles:@"Restart quiz", nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[popupQuery showInView:[UIApplication sharedApplication].keyWindow];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
	if (buttonIndex == 0) {
        if ([self.navigationController.viewControllers objectAtIndex:1] != nil) {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }
		
	} else if (buttonIndex == 1) {
        [self viewDidLoad];
        
	} else if (buttonIndex == 2) {
		
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

-(void)buttonPressed:(int)buttonIndex {
    
    if ([[[[[questions objectAtIndex:questionAtm-1] objectAtIndex:2] objectAtIndex:buttonIndex-1] objectAtIndex:2] intValue] == 1) {
        correctAnswersNumber++;
    }
    
    [self presentNextQuestion];
    
}
@end
