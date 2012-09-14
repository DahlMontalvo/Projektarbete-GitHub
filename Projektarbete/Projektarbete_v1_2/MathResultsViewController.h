//
//  MathResultsViewController.h
//  Projektarbete_v1_2
//
//  Created by Jonas Dahl on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"

@interface MathResultsViewController : UIViewController {
    int results;
    int difficulty;
    NSString *operation;
    NSString *gamemode;
    float finalTime;
}

@property (nonatomic) int results;
@property (nonatomic) int difficulty;
@property (nonatomic) float finalTime;
@property (strong, nonatomic) NSString *operation;
@property (strong, nonatomic) NSString *gamemode;

@property (strong, nonatomic) IBOutlet UILabel *resultsLabel;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *gamemodeLabel;
@property (strong, nonatomic) IBOutlet UILabel *highscoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *starLabel;

@property (retain, nonatomic) IBOutlet UINavigationItem *navItem;
- (IBAction)continueButtonPressed:(id)sender;

@end
