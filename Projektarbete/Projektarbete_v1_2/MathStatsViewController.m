//
//  MathStatsViewController.m
//  Simple Science
//
//  Copyright (c) 2013 Jonas Dahl & Philip Montalvo. All rights reserved.
//

#import "MathStatsViewController.h"

@implementation MathStatsViewController

@synthesize difficulty, section, operation, tableView;

#pragma mark - Initialization

#pragma mark - View management
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    operations = [[NSMutableArray alloc] init];
    [operations addObject:@"Addition"];
    [operations addObject:@"Subtraction"];
    [operations addObject:@"Multiplication"];
    [operations addObject:@"Division"];
    [operations addObject:@"Percent"];
    [operations addObject:@"Fratction"];
    [operations addObject:@"Equations"];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    tableView.backgroundColor = [UIColor clearColor];
    tableView.opaque = NO;
    tableView.backgroundView = nil;
    tableView.separatorColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view
- (UIView *) tableView:(UITableView *)tableViewObject viewForHeaderInSection:(NSInteger)sectionInt {
	UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 44.0)];
	
	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.opaque = NO;
	headerLabel.textColor = [UIColor whiteColor];
	headerLabel.highlightedTextColor = [UIColor whiteColor];
	headerLabel.font = [UIFont fontWithName:@"Marion" size:20];
	headerLabel.frame = CGRectMake(10.0, 0.0, 300.0, 44.0);
	headerLabel.text = [operations objectAtIndex:sectionInt];
	[customView addSubview:headerLabel];
    
	return customView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableViewObject {
    return [operations count];
}

- (NSInteger)tableView:(UITableView *)tableViewObject numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (NSString *)tableView:(UITableView *)tableViewObject titleForHeaderInSection:(NSInteger)localSection {
    return [operations objectAtIndex:localSection];
}

- (UITableViewCell *)tableView:(UITableView *)tableViewObject cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    difficulty = indexPath.row+1;
    section = indexPath.section;
    
    float value = [[[Singleton sharedSingleton] sharedPrefs] floatForKey:[NSString stringWithFormat:@"%@%i", [operations objectAtIndex:section], difficulty]];
    NSString *highscore;
    
    if (value == 0)
        highscore = @"None";
    else {
        int time = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:[NSString stringWithFormat:@"%@%i", [operations objectAtIndex:section], difficulty]];
        highscore = [NSString stringWithFormat:@"%i", time];
    }
    
    NSString *cellID = [operations objectAtIndex:section];
    
    StatsTableCellController *cell = (StatsTableCellController *)[tableViewObject dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StatsTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.titleLabel.text = [NSString stringWithFormat:@"Level %i", difficulty];
    cell.descriptionLabel.text = @"Highscore";
    
    int stars = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:[NSString stringWithFormat:@"Stars%@%i",[operations objectAtIndex:section],difficulty]];
    NSString *name;
    
    switch (stars) {
        case 0:
            name = @"NoStars.png";
            break;
        case 1:
            name = @"OneStars.png";
            break;
        case 2:
            name = @"TwoStars.png";
            break;
        case 3:
            name = @"ThreeStars.png";
            break;
        default:
            name = @"NoStars.png";
            break;
    }
    
    cell.starsImage.image = [UIImage imageNamed:name];
    cell.valueLabel.text = highscore;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableViewObject didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableViewObject deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Others
- (IBAction)pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
