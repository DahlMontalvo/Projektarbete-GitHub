//
//  StatsViewController.h
//  Projektarbete_v1_2
//
//  Created by Philip Montalvo on 2012-07-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
#import "StatsTableCellController.h"
#import "GlobalStatsViewController.h"

@interface StatsViewController : UITableViewController {
    NSMutableArray *operations;
    NSString *operation;
}

@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;
@property (nonatomic) int difficulty;
@property (nonatomic) int section;
@property (strong, nonatomic) NSString *operation;



@end
