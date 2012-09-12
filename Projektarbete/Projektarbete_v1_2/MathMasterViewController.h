//
//  ViewController.h
//  Projektarbete_v1_2
//
//  Created by Jonas Dahl on 9/11/12.
//
//

#import <UIKit/UIKit.h>
#import "MathDetailViewController.h"
#import "MathTableCellController.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *operations;
    NSMutableArray *otherExercises;
    NSString *operation;
    NSString *otherExercise;
}

@property (nonatomic, retain) NSString *operation;
@property (nonatomic, retain) NSString *otherExercise;

@property (weak, nonatomic) IBOutlet UIButton *Back;
@property (nonatomic, retain)IBOutlet UITableView *tableView;
- (IBAction)Button:(id)sender;


@end
