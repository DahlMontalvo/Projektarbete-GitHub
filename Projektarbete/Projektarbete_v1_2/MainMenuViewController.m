//
//  MainMenuViewController.m
//  Projektarbete_v1_2
//
//  Created by Philip Montalvo on 2012-07-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainMenuViewController.h"

@implementation MainMenuViewController
@synthesize redBanner, scrollViewGr, scrollView, greenBanner, chemistryPercentLabel, mathPercentLabel, biologyPercentLabel, physicsPercentLabel, biologyCategories, physicsCategories, chemistryCategories;

#pragma mark - Initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

#pragma mark - View management
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[[Singleton sharedSingleton] sharedPrefs] boolForKey:@"ApplicationHasOpenedBefore"] != YES) {
        //First run
        [[[Singleton sharedSingleton] sharedPrefs] setObject:[NSDate date] forKey:@"LastSyncDate"];
        [[[Singleton sharedSingleton] sharedPrefs] setBool:YES forKey:@"ApplicationHasOpenedBefore"];
    }
    
    //Setting up Settings and About scroll views
    scrollView.scrollEnabled = YES;
    scrollView.contentSize = scrollView.frame.size;
    [scrollView setAlwaysBounceVertical:YES];
    
    scrollViewGr.scrollEnabled = YES;
    scrollViewGr.contentSize = scrollViewGr.frame.size;
    [scrollViewGr setAlwaysBounceVertical:YES];
    
    
    [self performSelector:@selector(updateNumbers) withObject:nil afterDelay:1];
}

- (void)updateNumbers {
    BOOL again = YES;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate readQuestionsFromDatabase];
    //Samla underkategorierna i sina arrayer beroende på överkategori
    biologyCategories = [[NSMutableArray alloc] init];
    chemistryCategories = [[NSMutableArray alloc] init];
    physicsCategories = [[NSMutableArray alloc] init];
    
    NSLog(@"App.count: %i", [appDelegate.categories count]);
    
    for (int i = 0; i < [appDelegate.categories count]; i++) {
        NSString *name = [[appDelegate.categories objectAtIndex:i] objectAtIndex:0];
        NSString *parent = [[appDelegate.categories objectAtIndex:i] objectAtIndex:1];
        int ID = [[[appDelegate.categories objectAtIndex:i] objectAtIndex:2] intValue];
        NSMutableArray *temp = [[NSMutableArray alloc] initWithObjects:name, parent, [NSNumber numberWithInt:ID], nil];
        NSString *subject = [[appDelegate.categories objectAtIndex:i] objectAtIndex:1];
        
        if ([subject isEqualToString:@"Physics"])
            [physicsCategories addObject:temp];
        else if ([subject isEqualToString:@"Chemistry"])
            [chemistryCategories addObject:temp];
        else if ([subject isEqualToString:@"Biology"])
            [biologyCategories addObject:temp];
        NSLog(@"name: %@", name);
    }
    
    NSLog(@"Nu: %i", [[[Singleton sharedSingleton] sharedPrefs] boolForKey:@"ApplicationHasOpenedBefore"]);
    
    //Lägger in kategorierna med deras labels
    NSMutableArray *contents = [[NSMutableArray alloc] initWithObjects:[[NSMutableArray alloc] initWithObjects: chemistryCategories,
                                                                                                                physicsCategories,
                                                                                                                biologyCategories, nil],
                                [[NSMutableArray alloc] initWithObjects:chemistryPercentLabel,
                                                                        physicsPercentLabel,
                                                                        biologyPercentLabel, nil], nil];
    NSMutableArray *subjects = [[NSMutableArray alloc] initWithObjects:@"Chemistry", @"Physics", @"Biology", nil];
    
    //Loopar igenom ett ämne i taget
    for (int a = 0; a < 3; a++) {
        int total = 0;
        int stars = 0;
        float share = 0;
        //Loopar igenom alla kategorier i ämnet
        int loop = [[[contents objectAtIndex:0] objectAtIndex:a] count];
        NSLog(@"Loop:%i", loop);
        for (int i = 0; i < loop; i++) {
            NSString *key = [NSString stringWithFormat:@"NatureCategory%iStars", [[[[[contents objectAtIndex:0] objectAtIndex:a] objectAtIndex:i] objectAtIndex:2] intValue]];
            int thisStars = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:key];
            NSLog(@"thisStars: %i", thisStars);
            total+=3;
            stars+=thisStars;
            again = NO;
        }
        
        //Lägg till mixed
        total+=3;
        stars+=[[[Singleton sharedSingleton] sharedPrefs] integerForKey:[NSString stringWithFormat:@"NatureCategory%@Mixed", [subjects objectAtIndex:a]]];
        
        if (total != 0)
            share = (float)stars/(float)total;
        else
            share = 0;
        
        share*=100;
        
        UILabel *label = [[contents objectAtIndex:1] objectAtIndex:a];
        [label setText:[NSString stringWithFormat:@"%i %%", (int)(share+0.5)]];
        NSLog(@"String: %f", share);
    }
    if (again == YES)
        [self performSelector:@selector(updateNumbers) withObject:nil afterDelay:.5];
}

- (void)viewDidUnload {
    [self setRedBanner:nil];
    [self setGreenBanner:nil];
    [self setGreenBanner:nil];
    [self setMathPercentLabel:nil];
    [self setChemistryPercentLabel:nil];
    [self setPhysicsPercentLabel:nil];
    [self setBiologyPercentLabel:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated {
    //Ta bort status bar
    UIApplication *app = [UIApplication sharedApplication];
    [app setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    [self updateNumbers];
    
    //Matteprocent
    int total = 0;
    int stars = 0;
    
    NSMutableArray *operations = [[NSMutableArray alloc] initWithObjects:@"Addition", @"Subtraction", @"Division", @"Multiplication", @"Percent", @"Fraction", @"Equations", nil];
    for (int i = 0; i < 7; i++) {
        NSString *key = [NSString stringWithFormat:@"TotalStars%@", [operations objectAtIndex:i]];
        
        int thisStars = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:key];
        total+=15;
        stars+=thisStars;
    }
    
    float share = 100*((float)stars/total);
    mathPercentLabel.text = [NSString stringWithFormat:@"%i %%", (int)(share+0.5)];
    
    [[self.navigationController navigationBar] setTintColor:[UIColor blackColor]];
    [[self.navigationController navigationBar] setHidden:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Others
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

- (IBAction)redBanner:(id)sender {
    [self performSegueWithIdentifier:@"StatsSegue" sender:sender];
}

- (IBAction)greenBanner:(id)sender {
    [self performSegueWithIdentifier:@"AboutSegue" sender:sender];
}

- (void)GlobalStatsViewControllerDidDone:(GlobalStatsViewController *)controller {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)AboutViewControllerDidDone:(AboutViewController *)controller {
	[self dismissViewControllerAnimated:YES completion:nil];
}


@end
