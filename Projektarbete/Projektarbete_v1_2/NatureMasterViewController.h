//
//  NatureMasterViewController.h
//  Simple Science
//
//  Copyright (c) 2013 Jonas Dahl & Philip Montalvo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "NatureCategoryCellController.h"
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
