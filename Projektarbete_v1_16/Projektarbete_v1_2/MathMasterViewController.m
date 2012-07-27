//
//  MathMasterViewController2.m
//  Projektarbete_v1_2
//
//  Created by Jonas Dahl on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MathMasterViewController.h"


@implementation MathMasterViewController

@synthesize otherExercise;
@synthesize operation;

- (id)initWithStyle:(UITableViewStyle)style
{
    //self = [super initWithStyle:style];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self.navigationController navigationBar] setTintColor:[UIColor colorWithRed:0.5 green:0.0 blue:0.0 alpha:1.0]];
    
    operations = [[NSMutableArray alloc] init];
    otherExercises = [[NSMutableArray alloc] init];
    
    //För att lägga till ämnen, lägg till här och gör en ny segue på storyborden med identifyer samma
    [operations addObject:@"Addition"];
    [operations addObject:@"Subtraction"];
    [operations addObject:@"Multiplication"];
    [operations addObject:@"Division"];
    
    [otherExercises addObject:@"Percent"];
    [otherExercises addObject:@"Fraction"];
    [otherExercises addObject:@"Equations"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [operations count];
    }
    else {
        return [otherExercises count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return @"Basic Operations";
    }
    else {
        return @"More";
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier;
    NSString *cellValue;
    
    if (indexPath.section == 0) {
        CellIdentifier = [operations objectAtIndex:indexPath.row];
        
        cellValue = [operations objectAtIndex:indexPath.row];
        
        MathTableCellController *cell = (MathTableCellController *)[tableView dequeueReusableCellWithIdentifier:operation];
        if (cell == nil) 
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MathTableCellController" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        } 
        
        cell.titleLabel.text = [operations objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[operations objectAtIndex:indexPath.row]]];

        cell.valueLabel.text = @"";
        
        return cell;
    }
    else {
        CellIdentifier = [otherExercises objectAtIndex:indexPath.row];
        
        cellValue = [otherExercises objectAtIndex:indexPath.row];
        
        MathTableCellController *cell = (MathTableCellController *)[tableView dequeueReusableCellWithIdentifier:operation];
        if (cell == nil) 
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MathTableCellController" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        } 
        
        cell.titleLabel.text = [otherExercises objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[otherExercises objectAtIndex:indexPath.row]]];
        cell.valueLabel.text = @"";
        
        return cell;
    }
    
    
   

}
/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MathDetailViewController *dvc = [segue destinationViewController];
    dvc.operation = ;
    
}*/

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MathDetailViewController *dvc = [segue destinationViewController];    
    NSLog(@"Operation = %@", operation);
    NSLog(@"OtherExercise = %@", otherExercise);
    dvc.operation = operation;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        operation = [operations objectAtIndex:indexPath.row];
    }
    else {
        operation = [otherExercises objectAtIndex:indexPath.row];
    }

    [self performSegueWithIdentifier:@"ToDetail" sender:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate


@end
