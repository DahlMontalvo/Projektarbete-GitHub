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
@synthesize greenBanner, chemistryPercentLabel, mathPercentLabel, biologyPercentLabel, physicsPercentLabel;

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
    [self setMathPercentLabel:nil];
    [self setChemistryPercentLabel:nil];
    [self setPhysicsPercentLabel:nil];
    [self setBiologyPercentLabel:nil];
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
    
    NSLog(@"Jag kallar på dig.");
    
    [[[Singleton sharedSingleton] sharedPrefs] synchronize];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSMutableArray *biologyCategories = [[NSMutableArray alloc] init];
    NSMutableArray *chemistryCategories = [[NSMutableArray alloc] init];
    NSMutableArray *physicsCategories = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [appDelegate.categories count]; i++) {
        NSString *name = [[appDelegate.categories objectAtIndex:i] objectAtIndex:0];
        NSString *parent = [[appDelegate.categories objectAtIndex:i] objectAtIndex:1];
        int ID = [[[appDelegate.categories objectAtIndex:i] objectAtIndex:2] intValue];
        NSMutableArray *temp = [[NSMutableArray alloc] initWithObjects:name, parent, [NSNumber numberWithInt:ID], nil];
        
        if ([[[appDelegate.categories objectAtIndex:i] objectAtIndex:1] isEqualToString:@"Physics"])
            [physicsCategories addObject:temp];
        else if ([[[appDelegate.categories objectAtIndex:i] objectAtIndex:1] isEqualToString:@"Chemistry"])
            [chemistryCategories addObject:temp];
        else if ([[[appDelegate.categories objectAtIndex:i] objectAtIndex:1] isEqualToString:@"Biology"])
            [biologyCategories addObject:temp];
        
    }
    
    NSMutableArray *contents = [[NSMutableArray alloc] initWithObjects:[[NSMutableArray alloc] initWithObjects:chemistryCategories, physicsCategories, biologyCategories, nil], [[NSMutableArray alloc] initWithObjects:chemistryPercentLabel, physicsPercentLabel, biologyPercentLabel, nil], nil];
    
    for (int a = 0; a < 3; a++) {
        int total = 0;
        int stars = 0;
        float share = 0;
        
        NSLog(@"Här?");
        for (int i = 0; i < [[[contents objectAtIndex:0] objectAtIndex:a] count]; i++) {
            int thisStars = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:[NSString stringWithFormat:@"NatureCategory%iStars", [[[[[contents objectAtIndex:0] objectAtIndex:a] objectAtIndex:i] objectAtIndex:2] intValue]]];
            total+=3;
            stars+=thisStars;
            NSLog(@"Här?");
        }
        
        if (total != 0)
            share = (float)stars/(float)total;
        else
            share = 0;
        
        share*=100;
        
        [[[contents objectAtIndex:1] objectAtIndex:a] setText:[NSString stringWithFormat:@"%i %%", (int)(share+0.5)]];
        
    }
    
    int total = 0;
    int stars = 0;
    
    NSMutableArray *operations = [[NSMutableArray alloc] initWithObjects:@"Addition", @"Subtraction", @"Division", @"Multiplication", @"Percent", @"Fraction", @"Equations", nil];
    for (int i = 0; i < 7; i++) {
        NSString *key = [NSString stringWithFormat:@"TotalStars%@", [operations objectAtIndex:i]];
        
        int thisStars = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:key];
        total+=15;
        stars+=thisStars;
        NSLog(@"stars %i, %i", total, stars);
    }
    
    float share = 100*((float)stars/total);
    mathPercentLabel.text = [NSString stringWithFormat:@"%i %%", (int)(share+0.5)];
    
    
    
       [[self.navigationController navigationBar] setTintColor:[UIColor blackColor]];
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
