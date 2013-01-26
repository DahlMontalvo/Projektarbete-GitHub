//
//  MathExerciseViewController.h
//  Simple Science
//
//  Copyright (c) 2013 Jonas Dahl & Philip Montalvo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MathResultsViewController.h"
#import "MathMasterViewController.h"
#include "stdlib.h"


@interface MathExerciseViewController : UIViewController <UIActionSheetDelegate> {
    NSString *operation;
    int difficulty;
    NSDate *start_date;
    NSDate *start_countdown_date;
    NSTimeInterval time_passed;
    NSTimer *timer;
    NSString *gameMode;
    float countdownCounter;
    BOOL cancelCountdown;
    float finalTime;
    NSDate *testDate;
    NSMutableArray *quizArray;
    NSTimeInterval interval;
    NSTimer *countdownTimer;
    BOOL testStarted;
}
@property (weak, nonatomic) IBOutlet UILabel *startCountdownLabel;
@property (weak, nonatomic) IBOutlet UIView *darkView;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (strong, nonatomic) IBOutlet UIButton *pauseButton;
@property (strong, nonatomic) IBOutlet UILabel *countdownLabel;
@property (strong, nonatomic) IBOutlet UILabel *correctAnswersLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberLabel;
@property (strong, nonatomic) IBOutlet UILabel *answerFromUser;
@property (strong, nonatomic) IBOutlet UILabel *exerciseLabel;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (retain, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UIButton *keyboard1;
@property (weak, nonatomic) IBOutlet UIButton *keyboard2;
@property (weak, nonatomic) IBOutlet UIButton *keyboard3;
@property (weak, nonatomic) IBOutlet UIButton *keyboard4;
@property (weak, nonatomic) IBOutlet UIButton *keyboard5;
@property (weak, nonatomic) IBOutlet UIButton *keyboard6;
@property (weak, nonatomic) IBOutlet UIButton *keyboard7;
@property (weak, nonatomic) IBOutlet UIButton *keyboard8;
@property (weak, nonatomic) IBOutlet UIButton *keyboard9;
@property (weak, nonatomic) IBOutlet UIButton *keyboard0;
@property (weak, nonatomic) IBOutlet UIButton *keyboardback;

@property (nonatomic, retain) NSMutableArray *quizArray;
@property (nonatomic, retain) NSString *operation;
@property (nonatomic) int questionAtm;
@property (nonatomic) int difficulty;
@property (nonatomic) int correctAnswers;
@property (nonatomic) float answer;
@property (nonatomic) BOOL testStarted;
@property (nonatomic) float finalTime;
@property (nonatomic, retain) NSString *gameMode;
@property (assign) float countdownCounter;
@property (nonatomic) BOOL cancelCountdown;
@property (nonatomic, retain) NSDate *start_countdown_date;
@property (nonatomic) NSTimeInterval interval;
@property (nonatomic) float startCountdown;
@property (nonatomic, retain) NSTimer *startCountdownTimer;
@property (nonatomic, retain) NSDate *startCountdownDate;
@property (nonatomic) float startCountdownCounter;
@property (nonatomic) bool decimalSignInserted;

- (IBAction)keyboard1:(id)sender;
- (IBAction)keyboard2:(id)sender;
- (IBAction)keyboard3:(id)sender;
- (IBAction)keyboard4:(id)sender;
- (IBAction)keyboard5:(id)sender;
- (IBAction)keyboard6:(id)sender;
- (IBAction)keyboard7:(id)sender;
- (IBAction)keyboard8:(id)sender;
- (IBAction)keyboard9:(id)sender;
- (IBAction)keyboard0:(id)sender;
- (IBAction)keyboardback:(id)sender;

- (IBAction)nextButton:(id)sender;
- (IBAction)pausePressed:(id)sender;
- (void)nextButtonPressed;

@end

