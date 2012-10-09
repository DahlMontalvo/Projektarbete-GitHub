//
//  AboutViewController.h
//  Projektarbete_v1_2
//
//  Created by Philip Montalvo on 2012-07-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"

@class AboutViewController;

@protocol AboutViewControllerDelegate <NSObject, MFMailComposeViewControllerDelegate, NSXMLParserDelegate>
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

@property (nonatomic) BOOL errorParsing;
@property (nonatomic, retain) NSXMLParser *rssParser;
@property (nonatomic, retain) NSMutableArray *articles;
@property (nonatomic, retain) NSMutableDictionary *item;
@property (nonatomic, retain) NSString *currentElement;
@property (nonatomic, retain) NSString *currentPart;
@property (nonatomic, retain) NSMutableString *elementValue;

@end
