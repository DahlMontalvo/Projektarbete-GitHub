//
//  StatsViewController.h
//  Simple Science
//
//  Copyright (c) 2013 Jonas Dahl & Philip Montalvo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import "MathStatsViewController.h"
#import "NatureStatsViewController.h"
#import "GameKitHelper.h"

@class StatsViewController;

@protocol StatsViewControllerDelegate <NSObject>

- (void)StatsViewControllerDidDone:(StatsViewController *)controller;

@end

@interface StatsViewController : UIViewController <UIActionSheetDelegate> {
}

@property (strong, nonatomic)IBOutlet UIBarButtonItem *doneButton;
@property (nonatomic, strong) IBOutlet UILabel *completedTestsLabel;
@property (nonatomic, strong) IBOutlet UILabel *tenOutOfTensLabel;
@property (nonatomic, strong) IBOutlet UILabel *bestHighscoreLabel;
@property (nonatomic, strong) IBOutlet UILabel *mostPlayedSubjectLabel;
@property (strong, nonatomic) IBOutlet UILabel *overallProgressLabel;
@property (strong, nonatomic) IBOutlet UILabel *averageCorrectQuestionsLabel;
@property (strong, nonatomic) IBOutlet UILabel *averageHighscoreLabel;
@property (strong, nonatomic) IBOutlet UIButton *infoButton;
@property (strong, nonatomic) IBOutlet UIButton *leaderboardsButton;
@property (nonatomic, retain) NSString *subject;
@property (nonatomic, weak) id <StatsViewControllerDelegate> delegate;

-(IBAction)clearAll:(id)sender;
-(IBAction)done:(id)sender;
- (IBAction)physicsButtonPressed:(id)sender;
- (IBAction)chemistryButtonPressed:(id)sender;
- (IBAction)biologyButtonPressed:(id)sender;
- (IBAction)downButtonPressed:(id)sender;
- (IBAction)infoButtonPressed:(id)sender;
- (IBAction)leaderboards:(id)sender;



@end
