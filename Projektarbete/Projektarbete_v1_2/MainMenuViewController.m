//
//  MainMenuViewController.m
//  Projektarbete_v1_2
//
//  Created by Philip Montalvo on 2012-07-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainMenuViewController.h"

@implementation MainMenuViewController
@synthesize scrollView;
@synthesize scrollViewGr;
@synthesize redBanner;
@synthesize greenBanner;


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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    NSLog(@"Haha");
	if ([segue.identifier isEqualToString:@"GlobalStatsSegue"]) {
		UINavigationController *navigationController = segue.destinationViewController;
		GlobalStatsViewController *globalVC = [[navigationController viewControllers] objectAtIndex:0];
		globalVC.delegate = self;
        
	}
    else if ([segue.identifier isEqualToString:@"AboutSegue"]) {
		UINavigationController *navigationController = segue.destinationViewController;
		AboutViewController *aboutVC = [[navigationController viewControllers] objectAtIndex:0];
		aboutVC.delegate = self;
        
	}
    else if ([segue.identifier isEqualToString:@"Chemistry"]) {
		NatureMasterViewController *nvc = segue.destinationViewController;
        nvc.subject = @"Chemistry";
	}
    else if ([segue.identifier isEqualToString:@"Physics"]) {
		NatureMasterViewController *nvc = segue.destinationViewController;
        nvc.subject = @"Physics";
	}
    else if ([segue.identifier isEqualToString:@"Biology"]) {
		NatureMasterViewController *nvc = segue.destinationViewController;
        nvc.subject = @"Biology";
	}
    NSLog(@"Haha");
    
    
}

- (void)GlobalStatsViewControllerDidDone:(GlobalStatsViewController *)controller {
	[self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)AboutViewControllerDidDone:(AboutViewController *)controller {
	[self dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    scrollView.scrollEnabled = YES;
    self.scrollView.contentSize = self.scrollView.frame.size;
    [scrollView setAlwaysBounceVertical:YES];
    
    scrollViewGr.scrollEnabled = YES;
    self.scrollViewGr.contentSize = self.scrollViewGr.frame.size;
    [scrollViewGr setAlwaysBounceVertical:YES];
    
    [super viewDidLoad];
    
    [[self.navigationController navigationBar] setTintColor:[UIColor darkGrayColor]];
    /*
    [redBanner addTarget:self action:@selector(draggedOut:withEvent:)
        forControlEvents:UIControlEventTouchDragOutside |
     UIControlEventTouchDragInside];
    [greenBanner addTarget:self action:@selector(draggedOutGreen:withEvent:)
        forControlEvents:UIControlEventTouchDragOutside |
     UIControlEventTouchDragInside];
     */
}




- (void)viewDidUnload
{
    [self setRedBanner:nil];
    [self setGreenBanner:nil];
    [self setGreenBanner:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewDidAppear {
    
}
-(void)viewWillAppear:(BOOL)animated {
    
       [[self.navigationController navigationBar] setTintColor:[UIColor blackColor]];
   //  [[self.navigationController navigationBar] setBackgroundImage:<#(UIImage *)#> forBarMetrics:
        [[self.navigationController navigationBar] setHidden:YES];
    
    UIApplication *app = [UIApplication sharedApplication];
    [app setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}


- (IBAction)redBanner:(id)sender {

        [self performSegueWithIdentifier:@"StatsSegue" sender:sender];

    
}

- (IBAction)greenBanner:(id)sender {

        [self performSegueWithIdentifier:@"AboutSegue" sender:sender];

}

@end
