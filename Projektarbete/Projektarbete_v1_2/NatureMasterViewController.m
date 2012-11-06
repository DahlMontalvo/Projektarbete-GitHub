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

@synthesize subject, subjectLabel, tableView, categories, categoryID;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
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
    
    subjectLabel.text = subject;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TableViewBG2"]];
    self.tableView.backgroundView = imageView;
    
    [[self.navigationController navigationBar] setHidden:YES];
}

- (void)tableView:(UITableView *)localTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [localTableView deselectRowAtIndexPath:indexPath animated:NO];
    
    categoryID = [[[categories objectAtIndex:indexPath.row] objectAtIndex:2] intValue];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"ToDetail" sender:self];
}


- (void)viewDidUnload
{
    [self setSubjectLabel:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [categories count];
}

- (UITableViewCell *)tableView:(UITableView *)localTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int index = indexPath.row;
    NSString *CellIdentifier = [NSString stringWithFormat:@"%i", [[[categories objectAtIndex:index] objectAtIndex:2] intValue]];
    NSString *cellValue = [[categories objectAtIndex:index] objectAtIndex:0];
    NatureCategoryCell *cell = (NatureCategoryCell *)[localTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NatureCategoryCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.titleLabel.text = cellValue;
    return cell;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NatureDetailViewController *nvc = segue.destinationViewController;
    nvc.subject = subject;
    nvc.categoryID = categoryID;
}

@end
