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

@property (nonatomic) int categoryID;
@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSMutableArray *category;
- (IBAction)backButton:(id)sender;
@end
