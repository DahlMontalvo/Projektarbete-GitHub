//
//  AboutViewController.h
//  Simple Science
//
//  Copyright (c) 2013 Jonas Dahl & Philip Montalvo. All rights reserved.
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
@property (weak, nonatomic) IBOutlet UIButton *syncButton;
@property (nonatomic) BOOL errorParsing;
@property (weak, nonatomic) IBOutlet UIView *lightView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatior;
@property (nonatomic, retain) NSXMLParser *rssParser;
@property (nonatomic, retain) NSMutableArray *articles;
@property (nonatomic, retain) NSMutableDictionary *item;
@property (nonatomic, retain) NSString *currentElement;
@property (nonatomic, retain) NSString *currentPart;
@property (nonatomic, retain) NSMutableString *elementValue;
@property (nonatomic, retain) NSMutableArray *categoryChanges;
@property (nonatomic, retain) NSMutableArray *questionChanges;
@property (nonatomic, retain) NSMutableArray *answerChanges;
@property (nonatomic) int a;
@property (nonatomic) int questionsUpdated;
@property (nonatomic, retain) NSMutableArray *currentItem;

-(IBAction)done:(id)sender;
-(IBAction)emailPressed:(id)sender;
-(IBAction)syncButtonPressed:(id)sender;
-(IBAction)likeButtonPressed:(id)sender;
-(IBAction)feedBackFacebookButtonPressed:(id)sender;
-(void)startUpdating;

@end
