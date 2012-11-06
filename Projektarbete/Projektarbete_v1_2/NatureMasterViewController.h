//
//  BiologyMasterViewController.h
//  Projektarbete_v1_2
//
//  Created by Philip Montalvo on 2012-07-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "NatureCategoryCell.h"
#import "AppDelegate.h"
#import "NatureDetailViewController.h"

@interface NatureMasterViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSString *subject;
}

@property (retain, nonatomic) NSString *subject;
@property (nonatomic, retain) NSMutableArray *categories;
@property (nonatomic) int categoryID;

@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)backButton:(id)sender;

@end
