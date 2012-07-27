//
//  MathMasterViewController.h
//  Projektarbete_v1_2
//
//  Created by Jonas Dahl on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MathDetailViewController.h"
#import "MathTableCellController.h"


@interface MathMasterViewController : UITableViewController {
    NSMutableArray *operations;
    NSMutableArray *otherExercises;
    NSString *operation;
    NSString *otherExercise;
}

@property (nonatomic, retain) NSString *operation;
@property (nonatomic, retain) NSString *otherExercise;

@end