//
//  BiologyMasterViewController.m
//  Projektarbete_v1_2
//
//  Created by Philip Montalvo on 2012-07-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NatureMasterViewController.h"

@implementation NatureMasterViewController

@synthesize questionLabel, subject;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[self navigationItem] setTitle:subject];
    if ([subject isEqualToString:@"Biology"]) {
        [[self.navigationController navigationBar] setTintColor:[UIColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:1.0]];
    }
    else if ([subject isEqualToString:@"Physics"]) {
        [[self.navigationController navigationBar] setTintColor:[UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:1.0]];
    }
    else if ([subject isEqualToString:@"Chemistry"]) {
        [[self.navigationController navigationBar] setTintColor:[UIColor colorWithRed:0.2 green:0.2 blue:1.0 alpha:1.0]];
    }
    
    [[self.navigationController navigationBar] setHidden:NO];
    NSLog(@"Haha");
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    int randomNumber = arc4random() % ([appDelegate.questions count]);
    
	NSString *question = (NSString *)[appDelegate.questions objectAtIndex:randomNumber];
    questionLabel.text = question;
}


- (void)viewDidUnload
{
    [self setQuestionLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
