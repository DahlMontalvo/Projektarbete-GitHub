//
//  NatureMasterViewController.m
//  Simple Science
//
//  Copyright (c) 2013 Jonas Dahl & Philip Montalvo. All rights reserved.
//

#import "NatureMasterViewController.h"

@interface NatureMasterViewController ()

@end

@implementation NatureMasterViewController

@synthesize subject, subjectLabel, tableView, categories, categoryID;

#pragma mark - Initialization
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View management
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NatureDetailViewController *nvc = segue.destinationViewController;
    nvc.subject = subject;
    nvc.categoryID = categoryID;
}

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
    [tableView reloadData];
}

- (void)viewDidUnload {
    [self setSubjectLabel:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}

#pragma mark - Table view
- (void)tableView:(UITableView *)localTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [localTableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 1)
        categoryID = [[[categories objectAtIndex:indexPath.row] objectAtIndex:2] intValue];
    else
        categoryID = -1;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"ToDetail" sender:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if (section == 1)
        return [categories count];
    else
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)localTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    int index = indexPath.row;
    if (indexPath.section == 1) {
        NSString *CellIdentifier = [NSString stringWithFormat:@"%i", [[[categories objectAtIndex:index] objectAtIndex:2] intValue]];
        NSString *cellValue = [[categories objectAtIndex:index] objectAtIndex:0];
        NatureCategoryCellController *cell = (NatureCategoryCellController *)[localTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NatureCategoryCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        //Kolla detta 1/2
        int stars = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:[NSString stringWithFormat:@"NatureCategory%iStars", [[[categories objectAtIndex:indexPath.row] objectAtIndex:2] intValue]]];
    
        cell.titleLabel.text = cellValue;
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

        return cell;
    }
    else {
        NatureCategoryCellController *cell = (NatureCategoryCellController *)[localTableView dequeueReusableCellWithIdentifier:@"mixed"];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NatureCategoryCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        //och detta 2/2
        int stars = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:[NSString stringWithFormat:@"NatureCategory%@Mixed", subject]];
        
        cell.titleLabel.text = @"Mixed";
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

        return cell;
    }
}

#pragma mark - Others
- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
