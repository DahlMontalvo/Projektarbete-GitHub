//
//  MathQuizViewController.h
//  Projektarbete_v1_2
//
//  Created by Jonas Dahl on 9/12/12.
//
//

#import <UIKit/UIKit.h>
#import "MathResultsViewController.h"

@interface MathQuizViewController : UIViewController  <UIActionSheetDelegate> {
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
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstLineLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLineLabel;

@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
@property (weak, nonatomic) IBOutlet UILabel *correctAnswersLabel;
- (IBAction)pauseButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonThree;
@property (weak, nonatomic) IBOutlet UIButton *buttonFour;

@property (weak, nonatomic) IBOutlet UILabel *operationLabel;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UILabel *numeratorOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *numeratorTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *denominatorOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *denominatorTwoLabel;
@property (nonatomic) int correctButton;
@property (nonatomic, retain) NSMutableArray *quizArray;
@property (nonatomic, retain) NSMutableArray *questionArray;
@property (nonatomic, retain) NSMutableArray *answersArray;
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
@property (nonatomic, retain) NSString *correctString;

- (IBAction)buttonOne:(id)sender;
- (IBAction)buttonTwo:(id)sender;
- (IBAction)buttonThree:(id)sender;
- (IBAction)buttonFour:(id)sender;


@end
