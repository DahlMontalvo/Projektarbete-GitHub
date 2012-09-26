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

@interface MathDetailViewController : UIViewController {
    NSString *operation;
    IBOutlet UISegmentedControl *difficultySegmentedControl;
    IBOutlet UISegmentedControl *gamemodeSegmentedControl;
    IBOutlet UITextView *practiseTextField;
    IBOutlet UITextView *testTextField;
}
@property (weak, nonatomic) IBOutlet UIImageView *starsImage;
@property (weak, nonatomic) IBOutlet UILabel *starsLabel;

@property (strong, nonatomic) IBOutlet UIButton *testingButton;
@property (strong, nonatomic) IBOutlet UIButton *gameButton;
@property (strong, nonatomic) IBOutlet UIButton *practiseButton;
@property (weak, nonatomic) IBOutlet UILabel *navigationLabel;
@property (strong, nonatomic) IBOutlet UIButton *modeLabel;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (nonatomic, retain) NSString *operation;

- (IBAction)difficultySegmentedControl:(id)sender;
- (IBAction)gamemodeSegmentedControl:(id)sender;
- (IBAction)backButton:(id)sender;
- (IBAction)startButton:(id)sender;


@end
