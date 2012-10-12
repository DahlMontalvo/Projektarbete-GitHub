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
@property (nonatomic, retain) NSTimer *startCountdownTimer;
@property (nonatomic, retain) NSDate *startCountdownDate;
- (IBAction)pauseButtonPressed:(id)sender;
@property (nonatomic) float startCountdown;

@property (nonatomic) int categoryID;
@property (nonatomic) int correctAnswersNumber;
@property (nonatomic) int questionAtm;
@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSMutableArray *category;
- (IBAction)backButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (weak, nonatomic) IBOutlet UILabel *correctAnswers;
- (IBAction)buttonOne:(id)sender;
- (IBAction)buttonTwo:(id)sender;
- (IBAction)buttonThree:(id)sender;
- (IBAction)buttonFour:(id)sender;

@property (nonatomic, retain) NSMutableArray *questions;
@property (nonatomic, retain) AppDelegate *appDelegate;

@end
