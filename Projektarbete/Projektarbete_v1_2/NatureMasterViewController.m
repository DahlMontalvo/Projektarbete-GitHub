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

@synthesize questionLabel, subject, subjectLabel, tableView, categories, categoryID;

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
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    categories = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [appDelegate.categories count]; i++) {
        if ([[[appDelegate.categories objectAtIndex:i] objectAtIndex:1] isEqualToString:subject]) {
            NSString *name = [[appDelegate.categories objectAtIndex:i] objectAtIndex:0];
            NSString *parent = [[appDelegate.categories objectAtIndex:i] objectAtIndex:1];
            int ID = [[[appDelegate.categories objectAtIndex:i] objectAtIndex:2] intValue];
            NSMutableArray *temp = [[NSMutableArray alloc] initWithObjects:name, parent, [NSNumber numberWithInt:ID], nil];
            [categories addObject:temp];
        }
    }
    
    //int randomNumber = arc4random() % ([appDelegate.questions count]);
    
	//NSString *question = (NSString *)[appDelegate.questions objectAtIndex:randomNumber];
    //questionLabel.text = question;
    
    subjectLabel.text = subject;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TableViewBG2"]];
    self.tableView.backgroundView = imageView;
    
    [[self.navigationController navigationBar] setHidden:YES];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)tableView:(UITableView *)localTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [localTableView deselectRowAtIndexPath:indexPath animated:NO];
    
    categoryID = [[[categories objectAtIndex:indexPath.row] objectAtIndex:2] intValue];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"ToDetail" sender:self];
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
    
    return [categories count];
    
}

- (UITableViewCell *)tableView:(UITableView *)localTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier;
    NSString *cellValue;
    
    int index = indexPath.row;
    
    CellIdentifier = [NSString stringWithFormat:@"%i", [[[categories objectAtIndex:index] objectAtIndex:2] intValue]];
    
    cellValue = [[categories objectAtIndex:index] objectAtIndex:0];
    
    NatureCategoryCell *cell = (NatureCategoryCell *)[localTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSLog(@"RID: %@", CellIdentifier);
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NatureCategoryCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.titleLabel.text = cellValue;
    
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NatureDetailViewController *nvc = segue.destinationViewController;
    nvc.subject = subject;
    nvc.categoryID = categoryID;
    NSLog(@"ID i master: %i", categoryID);
}

@end
