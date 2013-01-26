//
//  MathMasterViewController.m
//  Simple Science
//
//  Copyright (c) 2013 Jonas Dahl & Philip Montalvo. All rights reserved.
//

#import "MathMasterViewController.h"

@interface MathMasterViewController ()

@end

@implementation MathMasterViewController

@synthesize tableView, operation, operations;

#pragma mark - Initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

#pragma mark - View management
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TableViewBG2"]];
    self.tableView.backgroundView = imageView;
    
    operations = [[NSMutableArray alloc] initWithObjects:@"Addition", @"Subtraction", @"Multiplication", @"Division", @"Percent", @"Fraction", @"Equations", nil];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)button:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *sectionTitle;
    if (section == 0) 
        sectionTitle = @"Basic";
    else 
        sectionTitle = @"More";
   
    //Skapa label med sectionTitle
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(30, 10, 280, 23);
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"Marion-Bold" size:22];

    label.text = sectionTitle;
    label.backgroundColor = [UIColor clearColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 100)];
    [view addSubview:label];
    
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return 4;
    else
        return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
     if (section == 0)
         return @"Basic operations";
     else
         return @"More";
}
 
- (UITableViewCell *)tableView:(UITableView *)localTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier;
    NSString *cellValue;
    
    int index = indexPath.row+(indexPath.section*4);
    
    CellIdentifier = [operations objectAtIndex:index];
    cellValue = [operations objectAtIndex:index];
    
    MathTableCellController *cell = (MathTableCellController *)[localTableView dequeueReusableCellWithIdentifier:operation];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MathTableCellController" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.titleLabel.text = [operations objectAtIndex:index];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[operations objectAtIndex:index]]];
    int stars = 0;
    for (int i = 1; i < 6; i++) {
        stars += [[[Singleton sharedSingleton] sharedPrefs] integerForKey:[NSString stringWithFormat:@"Stars%@%i", [operations objectAtIndex:index], i]];
    }
    cell.valueLabel.text = [NSString stringWithFormat:@"%i/15 Stars",stars];
    
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MathDetailViewController *dvc = [segue destinationViewController];
    dvc.operation = operation;
}

- (void)tableView:(UITableView *)localTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [localTableView deselectRowAtIndexPath:indexPath animated:NO];
    
    operation = [operations objectAtIndex:indexPath.row+(indexPath.section*4)];

    [self performSegueWithIdentifier:@"ToDetail" sender:self];
}

-(void)viewDidAppear:(BOOL)animated {
    
    [self.tableView reloadData];
}

@end
