//
//  NatureResultsViewController.h
//  Projektarbete_v1_2
//
//  Created by Jonas Dahl on 2012-10-12.
//
//

#import <UIKit/UIKit.h>

@interface NatureResultsViewController : UIViewController {
    
    int score;
    
}


@property (nonatomic) int score;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starsImageView;
- (IBAction)continueButtonPressed:(id)sender;

@end
