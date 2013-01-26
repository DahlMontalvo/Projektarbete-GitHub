//
//  NatureResultsViewController.h
//  Simple Science
//
//  Copyright (c) 2013 Jonas Dahl & Philip Montalvo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Singleton.h"

@interface NatureResultsViewController : UIViewController {
    int score;
    NSDate *testStartedDate;
    int categoryId;
    NSString *subject;
}

@property (weak, nonatomic) IBOutlet UILabel *starsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starsImageView;
@property (weak, nonatomic) IBOutlet UILabel *highscoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *description;
@property (strong, nonatomic) IBOutlet UILabel *scoreScoreLabel;

@property (nonatomic, retain) NSString *subject;
@property (nonatomic) int categoryId;
@property (nonatomic) int score;
@property (retain, nonatomic) NSDate *testStartedDate;

- (IBAction)continueButtonPressed:(id)sender;

@end
