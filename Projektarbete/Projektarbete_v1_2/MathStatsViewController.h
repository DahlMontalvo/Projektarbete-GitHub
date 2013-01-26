//
//  MathStatsViewController.h
//  Simple Science
//
//  Copyright (c) 2013 Jonas Dahl & Philip Montalvo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import "StatsTableCellController.h"
#import "StatsViewController.h"

@interface MathStatsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *operations;
    NSString *operation;
}

@property (nonatomic) int difficulty;
@property (nonatomic) int section;
@property (strong, nonatomic) NSString *operation;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

- (IBAction)pop:(id)sender;

@end
