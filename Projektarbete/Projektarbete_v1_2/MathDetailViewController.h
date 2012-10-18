//
//  MathDetailViewController.h
//  Projektarbete_v1_2
//
//  Created by Jonas Dahl on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MathQuizViewController.h"
#import "MathExerciseViewController.h"
#import "DifficultySegmentedControlButtonController.h"
#import "GamemodeSegmentedControlButtonController.h"

@interface MathDetailViewController : UIViewController {
    NSString *operation;
    IBOutlet UISegmentedControl *difficultySegmentedControl;
    IBOutlet UISegmentedControl *gamemodeSegmentedControl;
    IBOutlet UITextView *practiseTextField;
    IBOutlet UITextView *testTextField;
}
@property (weak, nonatomic) IBOutlet UIImageView *starsImage;
@property (weak, nonatomic) IBOutlet UILabel *starsLabel;
@property (nonatomic) int selectedOperation;
@property (weak, nonatomic) NSString *selectedGamemode;

@property (strong, nonatomic) IBOutlet UIButton *testingButton;
@property (strong, nonatomic) IBOutlet UIButton *gameButton;
@property (strong, nonatomic) IBOutlet UIButton *practiseButton;
@property (weak, nonatomic) IBOutlet UILabel *navigationLabel;
@property (strong, nonatomic) IBOutlet UIButton *modeLabel;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (nonatomic, retain) NSString *operation;
@property (nonatomic, retain) NSMutableArray *difficultyButtons;
@property (nonatomic, retain) NSMutableArray *gamemodeButtons;

- (IBAction)difficultySegmentedControl:(id)sender;
- (IBAction)gamemodeSegmentedControl:(id)sender;
- (IBAction)backButton:(id)sender;
- (IBAction)startButton:(id)sender;

- (IBAction)buttonOnePressed:(id)sender;
- (IBAction)buttonTwoPressed:(id)sender;
- (IBAction)buttonThreePressed:(id)sender;
- (IBAction)buttonFourPressed:(id)sender;
- (IBAction)buttonFivePressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonThree;
@property (weak, nonatomic) IBOutlet UIButton *buttonFour;
@property (weak, nonatomic) IBOutlet UIButton *buttonFive;
- (IBAction)buttonPractisePressed:(id)sender;
- (IBAction)buttonTestPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonPractise;
@property (weak, nonatomic) IBOutlet UIButton *buttonTest;


@end
