//
//  GlobalStatsViewController.h
//  Projektarbete_v1_2
//
//  Created by Philip Montalvo on 2012-07-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import "StatsViewController.h"
#import "NatureStatsViewController.h"




@class GlobalStatsViewController;

@protocol GlobalStatsViewControllerDelegate <NSObject>
- (void)GlobalStatsViewControllerDidDone:(GlobalStatsViewController *)controller;


@end

@interface GlobalStatsViewController : UIViewController <UIActionSheetDelegate> {
    
}
@property (strong, nonatomic)IBOutlet UIBarButtonItem *clearButton;
@property (strong, nonatomic)IBOutlet UIBarButtonItem *doneButton;
@property (nonatomic, strong) IBOutlet UILabel *completedTestsLabel;
@property (nonatomic, retain) NSString *subject;
@property (nonatomic, weak) id <GlobalStatsViewControllerDelegate> delegate;

-(IBAction)clearAll:(id)sender;
-(IBAction)done:(id)sender;
- (IBAction)physicsButtonPressed:(id)sender;
- (IBAction)chemistryButtonPressed:(id)sender;
- (IBAction)biologyButtonPressed:(id)sender;
- (IBAction)downButtonPressed:(id)sender;

@end
