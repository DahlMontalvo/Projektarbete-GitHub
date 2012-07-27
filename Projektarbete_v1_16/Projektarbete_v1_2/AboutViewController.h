//
//  AboutViewController.h
//  Projektarbete_v1_2
//
//  Created by Philip Montalvo on 2012-07-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AboutViewController;

@protocol AboutViewControllerDelegate <NSObject>
- (void)AboutViewControllerDidDone:(AboutViewController *)controller;


@end

@interface AboutViewController : UIViewController {
    
    
}

@property (nonatomic, weak) id <AboutViewControllerDelegate> delegate;
@property (strong, nonatomic)IBOutlet UIBarButtonItem *doneButton;

-(IBAction)done:(id)sender;

@end
