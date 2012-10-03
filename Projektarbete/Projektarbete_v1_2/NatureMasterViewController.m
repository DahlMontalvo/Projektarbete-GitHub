//
//  BiologyMasterViewController.m
//  Projektarbete_v1_2
//
//  Created by Philip Montalvo on 2012-07-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NatureMasterViewController.h"

@interface NatureMasterViewController ()

@end

@implementation NatureMasterViewController

@synthesize questionLabel, subject, subjectLabel, tableView;

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
    
    subjectLabel.text = subject;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TableViewBG2"]];
    self.tableView.backgroundView = imageView;
    
    [[self.navigationController navigationBar] setHidden:YES];
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
    [self setSubjectLabel:nil];
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    
    return 4;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;

}

- (UITableViewCell *)tableView:(UITableView *)localTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"Hej");
    
    NSString *CellIdentifier;
    NSString *cellValue;
    
    int index = indexPath.row;
    
    CellIdentifier = @"Hello";
    
    cellValue = [NSString stringWithFormat:@"Hello %i", index];
    
    /*MathTableCellController *cell = (MathTableCellController *)[localTableView dequeueReusableCellWithIdentifier:operation];
     */
    UITableViewCell *cell = [localTableView dequeueReusableCellWithIdentifier:@"Hello"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"Hello %i", index];
    
    return cell;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
