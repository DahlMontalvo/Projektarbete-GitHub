//
//  MainMenuViewController.h
//  Projektarbete_v1_2
//
//  Created by Philip Montalvo on 2012-07-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalStatsViewController.h"
#import "AboutViewController.h"
#import "NatureMasterViewController.h"
#import "Singleton.h"


@interface MainMenuViewController : UIViewController <GlobalStatsViewControllerDelegate, AboutViewControllerDelegate>  {
  
    
    
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollViewGr;
@property (weak, nonatomic) IBOutlet UIButton *redBanner;
@property (weak, nonatomic) IBOutlet UIButton *greenBanner;


- (IBAction)redBanner:(id)sender;
- (IBAction)greenBanner:(id)sender;

@property (retain, nonatomic) IBOutlet UIImageView *chemistryStars;
@property (strong, nonatomic) IBOutlet UIImageView *mathStars;
@property (strong, nonatomic) IBOutlet UIImageView *physicsStars;
@property (strong, nonatomic) IBOutlet UIImageView *biologyStars;



@end
