//
//  NatureStatsViewController.h
//  Simple Science
//
//  Copyright (c) 2013 Jonas Dahl & Philip Montalvo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "StatsTableCellController.h"
#import "Singleton.h"

@interface NatureStatsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSString *subject;
}

@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSMutableArray *categories;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (IBAction)pop:(id)sender;

@end
