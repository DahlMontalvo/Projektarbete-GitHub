//
//  ViewController.m
//  Projektarbete_v1_2
//
//  Created by Jonas Dahl on 9/11/12.
//
//

#import "MathMasterViewController.h"

@interface MathMasterViewController ()

@end

@implementation MathMasterViewController
@synthesize tableView;

@synthesize otherExercise;
@synthesize operation;
@synthesize sectionTitle;


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
    
    
    
  //  UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MathFirstBG4.png"]];
  //  self.tableView.backgroundView = imageView;
    
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
         sectionTitle = @"Basic";
    } else {
        sectionTitle = @"More";
    }
   
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(15, 5, 284, 23);
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"Gill Sans" size:20];

    label.text = sectionTitle;
    label.backgroundColor = [UIColor clearColor];
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    [view addSubview:label];
    
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 4;
    } else {
        return 3;
    }
    
}

 - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
 
     if (section == 0) {
         return @"Basic operations";
     }
     else {
         return @"More";
     }
}
 

- (UITableViewCell *)tableView:(UITableView *)localTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier;
    NSString *cellValue;
    
    int index = indexPath.row+(indexPath.section*4);
    
    CellIdentifier = [operations objectAtIndex:index];
    
    cellValue = [operations objectAtIndex:index];
    
    MathTableCellController *cell = (MathTableCellController *)[localTableView dequeueReusableCellWithIdentifier:operation];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MathTableCellController" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.titleLabel.text = [operations objectAtIndex:index];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[operations objectAtIndex:index]]];
    
    cell.valueLabel.text = [NSString stringWithFormat:@"%i/15 Stars",[[[Singleton sharedSingleton] sharedPrefs] integerForKey:[NSString stringWithFormat:@"TotalStars%@",[operations objectAtIndex:index]]]];
    
    
    
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

- (void)tableView:(UITableView *)localTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [localTableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 0) {
        operation = [operations objectAtIndex:indexPath.row];
    }
    else {
        operation = [otherExercises objectAtIndex:indexPath.row];
    }
    
    [self performSegueWithIdentifier:@"ToDetail" sender:self];
}

-(void)viewDidAppear:(BOOL)animated {
    
    [self.tableView reloadData];
}

@end
