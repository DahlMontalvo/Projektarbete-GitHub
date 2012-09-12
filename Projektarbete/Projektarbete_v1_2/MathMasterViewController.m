//
//  ViewController.m
//  Projektarbete_v1_2
//
//  Created by Jonas Dahl on 9/11/12.
//
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize Back;
@synthesize tableView;

@synthesize otherExercise;
@synthesize operation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MathFirstBG.png"]];
    
    self.tableView.backgroundView = imageView;
    
    operations = [[NSMutableArray alloc] init];
    otherExercises = [[NSMutableArray alloc] init];
    
    //För att lägga till ämnen, lägg till här och gör en ny segue på storyborden med identifyer samma
    [operations addObject:@"Addition"];
    [operations addObject:@"Subtraction"];
    [operations addObject:@"Multiplication"];
    [operations addObject:@"Division"];
    [operations addObject:@"Percent"];
    [operations addObject:@"Fraction"];
    [operations addObject:@"Equations"];
    [operations addObject:@"Mixed"];
    
    [otherExercises addObject:@"Percent"];
    [otherExercises addObject:@"Fraction"];
    [otherExercises addObject:@"Equations"];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setBack:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)Button:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return [operations count];
    } else {
        return 0;
    }
    
}
/*
 - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
 
 if (section == 0) {
 return @"Basic Operations";
 }
 else {
 return @"More";
 }
 }
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier;
    NSString *cellValue;
    
    
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
    
    cell.valueLabel.text = @"Stars: X/X";
    
    return cell;
}/*
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
  cell.valueLabel.text = @"Stars Collected: x/x";
  
  
  
  return cell;
  }
  
  
  
  
  }
  */
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

@end
