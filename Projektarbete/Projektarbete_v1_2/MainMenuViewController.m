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
@synthesize redBanner;


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
	if ([segue.identifier isEqualToString:@"GlobalStatsSegue"])
	{
		UINavigationController *navigationController = segue.destinationViewController;
		GlobalStatsViewController *globalVC = [[navigationController viewControllers] objectAtIndex:0];
		globalVC.delegate = self;
        
	}
    
    if ([segue.identifier isEqualToString:@"AboutSegue"])
	{
		UINavigationController *navigationController = segue.destinationViewController;
		AboutViewController *aboutVC = [[navigationController viewControllers] objectAtIndex:0];
		aboutVC.delegate = self;
        
	}

    
    
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
    scrollView.contentSize = CGSizeMake(320,460);
    
    [super viewDidLoad];
    
    [[self.navigationController navigationBar] setTintColor:[UIColor darkGrayColor]];
    
    [redBanner addTarget:self action:@selector(draggedOut:withEvent:)
         forControlEvents:UIControlEventTouchDragOutside |
     UIControlEventTouchDragInside];
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

- (void) draggedOut: (UIControl *) c withEvent: (UIEvent *) ev {
    CGPoint point = [[[ev allTouches] anyObject] locationInView:self.view];
     
    if(point.y > 387 && point.y <422) {
        c.center = CGPointMake(74, point.y);
    }
    
}

- (IBAction)redBanner:(id)sender {
    
    int y = redBanner.center.y;
    if (y > 419) {
        [self performSegueWithIdentifier:@"StatsSegue" sender:sender];
    }
    redBanner.center = CGPointMake(74, 422);
    
    
}

- (IBAction)greenBanner:(id)sender {
    [self performSegueWithIdentifier:@"AboutSegue" sender:sender];
}
@end
