//
//  NatureStatsViewController.h
//  Projektarbete_v1_2
//
//  Created by Jonas Dahl on 2012-10-15.
//
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
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)pop:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
