//
//  MathDetailViewController.h
//  Simple Science
//
//  Copyright (c) 2013 Jonas Dahl & Philip Montalvo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MathQuizViewController.h"
#import "MathExerciseViewController.h"
#import "DifficultySegmentedControlButtonController.h"
#import "GamemodeSegmentedControlButtonController.h"

@interface MathDetailViewController : UIViewController {
    NSString *operation;
    IBOutlet UITextView *practiseTextField;
    IBOutlet UITextView *testTextField;
}

@property (nonatomic) int selectedOperation;
@property (weak, nonatomic) NSString *selectedGamemode;
@property (nonatomic, retain) NSString *operation;
@property (nonatomic, retain) NSMutableArray *difficultyButtons;
@property (nonatomic, retain) NSMutableArray *gamemodeButtons;
@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonThree;
@property (weak, nonatomic) IBOutlet UIButton *buttonFour;
@property (weak, nonatomic) IBOutlet UIButton *buttonFive;
@property (weak, nonatomic) IBOutlet UIButton *buttonPractise;
@property (weak, nonatomic) IBOutlet UIButton *buttonTest;
@property (weak, nonatomic) IBOutlet UILabel *navigationLabel;
@property (strong, nonatomic) IBOutlet UIButton *modeLabel;
@property (strong, nonatomic) IBOutlet UIButton *startButton;

- (IBAction)backButton:(id)sender;
- (IBAction)startButton:(id)sender;
- (IBAction)buttonOnePressed:(id)sender;
- (IBAction)buttonTwoPressed:(id)sender;
- (IBAction)buttonThreePressed:(id)sender;
- (IBAction)buttonFourPressed:(id)sender;
- (IBAction)buttonFivePressed:(id)sender;
- (IBAction)buttonPractisePressed:(id)sender;
- (IBAction)buttonTestPressed:(id)sender;

@end
