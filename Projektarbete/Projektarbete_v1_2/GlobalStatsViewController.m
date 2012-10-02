//
//  GlobalStatsViewController.m
//  Projektarbete_v1_2
//
//  Created by Philip Montalvo on 2012-07-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GlobalStatsViewController.h"
#import "StatsViewController.h"

@implementation GlobalStatsViewController
@synthesize completedTestsLabel;
@synthesize completedPractisesLabel;
@synthesize clearButton;
@synthesize doneButton;
@synthesize delegate;

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
-(void)refreshView {
    
    int completedPractises = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"CompletedPractises"];
    int completedTests = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"CompletedTests"];
    
    
    completedPractisesLabel.text = [NSString stringWithFormat:@"%i",completedPractises];
    completedTestsLabel.text = [NSString stringWithFormat:@"%i",completedTests];
    
}

-(IBAction)done:(id)sender {
    [self.delegate GlobalStatsViewControllerDidDone:self];
}

-(IBAction)clearAll:(id)sender {
    
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Are you sure that you want to delete all stats?" delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:@"Yes" otherButtonTitles:nil, nil, nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[popupQuery showInView:self.view];    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
	if (buttonIndex == 0) {
        [[[Singleton sharedSingleton] sharedPrefs] setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];
        [self refreshView];
    }
    
} 

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *operation = [segue identifier];
    StatsViewController *evc = [segue destinationViewController];
    evc.operation = operation;
    
}




// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self refreshView];
}

- (void)viewDidUnload
{
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
