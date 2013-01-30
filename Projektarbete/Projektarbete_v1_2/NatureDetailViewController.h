//
//  NatureDetailViewController.h
//  Simple Science
//
//  Copyright (c) 2013 Jonas Dahl & Philip Montalvo. All rights reserved.
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
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UILabel *correctAnswers;

@property (nonatomic) float startCountdown;
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

- (IBAction)buttonOne:(id)sender;
- (IBAction)buttonTwo:(id)sender;
- (IBAction)buttonThree:(id)sender;
- (IBAction)buttonFour:(id)sender;

- (IBAction)buttonOnePressedDown:(id)sender;
- (IBAction)buttonTwoPressedDown:(id)sender;
- (IBAction)buttonThreePressedDown:(id)sender;
- (IBAction)buttonFourPressedDown:(id)sender;

- (IBAction)reportButtonPressed:(id)sender;
- (IBAction)pauseButtonPressed:(id)sender;
- (void)report;

@property (nonatomic, retain) NSMutableArray *questions;
@property (nonatomic, retain) AppDelegate *appDelegate;

@end
