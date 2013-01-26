//
//  MathMasterViewController.h
//  Simple Science
//
//  Copyright (c) 2013 Jonas Dahl & Philip Montalvo. All rights reserved.
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
