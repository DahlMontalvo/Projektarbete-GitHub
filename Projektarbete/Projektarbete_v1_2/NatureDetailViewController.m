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

@synthesize categoryID, subject, category, subjectLabel, questionLabel, buttonOne, buttonTwo, buttonThree, buttonFour, startCountdownTimer, countdownLabel, darkView, startCountdownDate, startCountdown, questions;

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
    [darkView setHidden:NO];
    startCountdownDate = [NSDate date];
    startCountdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f/10.0f
                                                           target:self
                                                         selector:@selector(startCountdownMethod)
                                                         userInfo:nil
                                                          repeats:YES];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    category = [[NSMutableArray alloc] init];
    
    category = [appDelegate getCategoryWithID:categoryID];
    
    NSLog(@"CategoryID: %i", categoryID);
    
    subjectLabel.text = [NSString stringWithFormat:@"%@: %@", subject, [category objectAtIndex:0]];
    
    NSMutableArray *nopId = [[NSMutableArray alloc] init];
    questions = [[NSMutableArray alloc] init];
    [nopId addObject:[NSNumber numberWithInt:-1]];
    
    int iteration = [appDelegate numbersOfQuestionsInCategory:categoryID];
    if (iteration > 10) {
        iteration = 10;
    }
    
    for (int i = 0; i<iteration; i++) {
        NSLog(@"i: %i", i);
        NSMutableArray *question = [appDelegate getQuestionInCategory:categoryID withOutIds:nopId];
        [nopId addObject:[question objectAtIndex:1]];
        [questions addObject:question];
    }
    
    NSMutableArray *question = [questions objectAtIndex:0];
    
    if (question != nil) {
        questionLabel.text = [question objectAtIndex:0];
        
        int random = 0;
        NSMutableArray *buttons = [[NSMutableArray alloc] initWithObjects:buttonOne, buttonTwo, buttonThree, buttonFour, nil];
        NSMutableArray *randoms = [[NSMutableArray alloc] init];
        //Random ordning
        for (int i = 0; i <= 3; i++) {
            NSLog(@"Hit");
            BOOL continueLoop = YES;
            while (continueLoop) {
                NSLog(@"Dit");
                int temp = arc4random() % 4;
                BOOL found = NO;
                for (int a = 0; a <= i-1; a++) {
                    NSLog(@"%i, %i, %i", a, [[randoms objectAtIndex:a] intValue], temp);
                    if ([[randoms objectAtIndex:a] intValue] == temp) {
                        found = YES;
                        NSLog(@"Found");
                    }
                    NSLog(@"Lit");
                }
                if (found == NO) {
                    NSLog(@"Skit");
                    random = temp;
                    continueLoop = NO;
                }
            }
            NSString *correct = @"";
            if ([[[[question objectAtIndex:2] objectAtIndex:i] objectAtIndex:2] intValue] == 1)
                correct = @" (rätt)";
            
            if (![[[[question objectAtIndex:2] objectAtIndex:i] objectAtIndex:0] isEqualToString:@"empty"]) {
                NSString *btnString = [NSString stringWithFormat:@"%@%@", [[[question objectAtIndex:2] objectAtIndex:i] objectAtIndex:0], correct];
                [[buttons objectAtIndex:random] setTitle:btnString forState:UIControlStateNormal];
            }
            [randoms addObject:[NSNumber numberWithInt:random]];
        }
        /*
        [buttonOne setTitle:[[[question objectAtIndex:2] objectAtIndex:0] objectAtIndex:0] forState:UIControlStateNormal];
        [buttonTwo setTitle:[[[question objectAtIndex:2] objectAtIndex:1] objectAtIndex:0] forState:UIControlStateNormal];
        [buttonThree setTitle:[[[question objectAtIndex:2] objectAtIndex:2] objectAtIndex:0] forState:UIControlStateNormal];
        [buttonFour setTitle:[[[question objectAtIndex:2] objectAtIndex:3] objectAtIndex:0] forState:UIControlStateNormal];
         */
        
    }
    else {
        questionLabel.text = @"Ingen fråga hittad.";
        
        [buttonOne setHidden:YES];
        [buttonTwo setHidden:YES];
        [buttonThree setHidden:YES];
        [buttonFour setHidden:YES];
    }
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
@end
