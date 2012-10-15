//
//  NatureResultsViewController.h
//  Projektarbete_v1_2
//
//  Created by Jonas Dahl on 2012-10-12.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Singleton.h"

@interface NatureResultsViewController : UIViewController {
    
    int score;
    NSDate *testStartedDate;
    int categoryId;
    
}


@property (nonatomic) int score;
@property (weak, nonatomic) IBOutlet UILabel *starsLabel;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starsImageView;
@property (retain, nonatomic) NSDate *testStartedDate;
@property (nonatomic) int categoryId;
- (IBAction)continueButtonPressed:(id)sender;

@end
