//
//  AboutViewController.h
//  Projektarbete_v1_2
//
//  Created by Philip Montalvo on 2012-07-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class AboutViewController;

@protocol AboutViewControllerDelegate <NSObject, MFMailComposeViewControllerDelegate>
- (void)AboutViewControllerDidDone:(AboutViewController *)controller;


@end

@interface AboutViewController : UIViewController {
    
    
}

@property (nonatomic, weak) id <AboutViewControllerDelegate> delegate;
@property (strong, nonatomic)IBOutlet UIBarButtonItem *doneButton;

-(IBAction)done:(id)sender;
-(IBAction)emailPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *syncButton;
- (IBAction)syncButtonPressed:(id)sender;

@end
