//
//  MathStartViewController.h
//  Projektarbete_v1_2
//
//  Created by Jonas Dahl on 9/12/12.
//
//

#import <UIKit/UIKit.h>
#import "MathQuizViewController.h"
#import "MathExerciseViewController.h"

@interface MathStartViewController : UIViewController {
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

- (IBAction)startButton:(id)sender;

@end
