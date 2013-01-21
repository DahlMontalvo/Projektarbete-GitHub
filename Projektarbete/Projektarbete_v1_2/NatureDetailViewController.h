//
//  NatureDetailViewController.h
//  Projektarbete_v1_2
//
//  Created by Jonas Dahl on 2012-10-03.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "NatureResultsViewController.h"

@interface NatureDetailViewController : UIViewController <UIActionSheetDelegate> {
    int categoryID;
    NSString *subject;
}

@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonThree;
@property (weak, nonatomic) IBOutlet UIButton *buttonFour;
@property (weak, nonatomic) IBOutlet UIView *darkView;
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
- (IBAction)pauseButtonPressed:(id)sender;
@property (nonatomic) float startCountdown;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;

@property (nonatomic) int categoryID;
@property (nonatomic) int correctAnswersNumber;
@property (nonatomic) int questionAtm;
@property (nonatomic) int lastSentErrorReport;
@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSMutableArray *category;
@property (nonatomic, retain) NSDate *testStartedDate;
@property (nonatomic, retain) NSDate *start_countdown_date;
@property (nonatomic) float countdownCounter;
@property (nonatomic) NSTimeInterval time_passed;
@property (nonatomic, retain) NSDate *start_date;
@property (nonatomic, retain) NSTimer *countdownTimer;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) NSTimer *startCountdownTimer;
@property (nonatomic, retain) NSDate *startCountdownDate;

@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UILabel *correctAnswers;

- (IBAction)buttonOne:(id)sender;
- (IBAction)buttonTwo:(id)sender;
- (IBAction)buttonThree:(id)sender;
- (IBAction)buttonFour:(id)sender;
- (IBAction)reportButtonPressed:(id)sender;

@property (nonatomic, retain) NSMutableArray *questions;
@property (nonatomic, retain) AppDelegate *appDelegate;

@end
