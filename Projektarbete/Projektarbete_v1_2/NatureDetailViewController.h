//
//  NatureDetailViewController.h
//  Projektarbete_v1_2
//
//  Created by Jonas Dahl on 2012-10-03.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface NatureDetailViewController : UIViewController {
    int categoryID;
    NSString *subject;
}
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonThree;
@property (weak, nonatomic) IBOutlet UIButton *buttonFour;

@property (nonatomic) int categoryID;
@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSMutableArray *category;
- (IBAction)backButton:(id)sender;
@end
