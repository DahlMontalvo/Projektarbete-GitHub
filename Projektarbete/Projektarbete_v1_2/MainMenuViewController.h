//
//  MainMenuViewController.h
//  Simple Science
//
//  Copyright (c) 2013 Jonas Dahl & Philip Montalvo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatsViewController.h"
#import "AboutViewController.h"
#import "NatureMasterViewController.h"
#import "Singleton.h"

@interface MainMenuViewController : UIViewController <StatsViewControllerDelegate, AboutViewControllerDelegate>  {
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollViewGr;
@property (weak, nonatomic) IBOutlet UIButton *redBanner;
@property (weak, nonatomic) IBOutlet UIButton *greenBanner;
@property (strong, nonatomic) IBOutlet UILabel *mathPercentLabel;
@property (strong, nonatomic) IBOutlet UILabel *chemistryPercentLabel;
@property (strong, nonatomic) IBOutlet UILabel *physicsPercentLabel;
@property (strong, nonatomic) IBOutlet UILabel *biologyPercentLabel;
@property (nonatomic, retain) NSMutableArray *chemistryCategories;
@property (nonatomic, retain) NSMutableArray *physicsCategories;
@property (nonatomic, retain) NSMutableArray *biologyCategories;

- (IBAction)redBanner:(id)sender;
- (IBAction)greenBanner:(id)sender;
- (void)updateNumbers;

@end