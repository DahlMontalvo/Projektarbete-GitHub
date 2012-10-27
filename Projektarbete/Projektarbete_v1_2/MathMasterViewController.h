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

@interface MathMasterViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) NSString *operation;
@property (nonatomic, retain) NSMutableArray *operations;

@property (nonatomic, retain) IBOutlet UITableView *tableView;

- (IBAction)button:(id)sender;

@end
