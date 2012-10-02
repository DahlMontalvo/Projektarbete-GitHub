//
//  BiologyMasterViewController.h
//  Projektarbete_v1_2
//
//  Created by Philip Montalvo on 2012-07-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface NatureMasterViewController : UIViewController {
    NSString *subject;
}

@property (nonatomic, retain) NSString *subject;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;

@end
