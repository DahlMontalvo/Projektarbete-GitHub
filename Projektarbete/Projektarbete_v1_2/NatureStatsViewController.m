//
//  NatureStatsViewController.m
//  Projektarbete_v1_2
//
//  Created by Jonas Dahl on 2012-10-15.
//
//

#import "NatureStatsViewController.h"

@interface NatureStatsViewController ()

@end

@implementation NatureStatsViewController

@synthesize subject, navItem, categories, titleLabel, tableView;

- (void)viewWillAppear:(BOOL)animated {
    
    tableView.backgroundColor = [UIColor clearColor];
    tableView.opaque = NO;
    tableView.backgroundView = nil;
    tableView.separatorColor = [UIColor clearColor];
    tableView.separatorStyle = nil;
    [super viewWillAppear:animated];
    
    [titleLabel setText:[NSString stringWithFormat:@"%@ Stats", subject]];
    
    NSLog(@"2");
    [navItem setTitle:[NSString stringWithFormat:@"%@",subject]];
    
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [categories count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0){
        NSString *cellID = @"MixedCell";
        StatsTableCellController *cell = (StatsTableCellController *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StatsTableCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.titleLabel.text = [NSString stringWithFormat:@"Mixed %@", subject ];
        cell.descriptionLabel.text = @"Highscore";
        
        
        int stars = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:[NSString stringWithFormat:@"NatureCategory%@Mixed", subject]];
        
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
        
        float value = [[[Singleton sharedSingleton] sharedPrefs] floatForKey:[NSString stringWithFormat:@"NatureCategory%@MixedTime",subject]];
        
        NSString *highscore;
        
        if (value == 0) {
            highscore = @"None";
        }
        else {
            float time = [[[Singleton sharedSingleton] sharedPrefs] floatForKey:[NSString stringWithFormat:@"NatureCategory%@MixedTime",subject]];
            
            highscore = [NSString stringWithFormat:@"%.2f s", time];
        }
        
        cell.valueLabel.text = highscore;
        
        
        return cell;
    }
    else {
    NSString *cellID = [[categories objectAtIndex:indexPath.row-1] objectAtIndex:0];
    StatsTableCellController *cell = (StatsTableCellController *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StatsTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.titleLabel.text = [[categories objectAtIndex:indexPath.row-1] objectAtIndex:0];
    cell.descriptionLabel.text = @"Highscore";
    
    
    int stars = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:[NSString stringWithFormat:@"NatureCategory%iStars", [[[categories objectAtIndex:indexPath.row-1] objectAtIndex:2] intValue]]];
    
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
    
    float value = [[[Singleton sharedSingleton] sharedPrefs] floatForKey:[NSString stringWithFormat:@"NatureCategory%iTime", [[[categories objectAtIndex:indexPath.row-1] objectAtIndex:2] intValue]]];
    
    NSString *highscore;
    
    if (value == 0) {
        highscore = @"None";
    }
    else {
        float time = [[[Singleton sharedSingleton] sharedPrefs] floatForKey:[NSString stringWithFormat:@"NatureCategory%iTime", [[[categories objectAtIndex:indexPath.row-1] objectAtIndex:2] intValue]]];
        
        highscore = [NSString stringWithFormat:@"%.2f s", time];
    }
    NSLog(@"%@", [NSString stringWithFormat:@"NatureCategory%iTime", [[[categories objectAtIndex:indexPath.row-1] objectAtIndex:2] intValue]]);
    
    cell.valueLabel.text = highscore;
    
    
    return cell;
    }
}

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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)viewDidUnload {
    [self setNavItem:nil];
    [self setTableView:nil];
    [self setTitleLabel:nil];
    [super viewDidUnload];
}

- (IBAction)pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
