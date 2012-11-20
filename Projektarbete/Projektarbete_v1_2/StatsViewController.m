//
//  StatsViewController.m
//  Projektarbete_v1_2
//
//  Created by Philip Montalvo on 2012-07-22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StatsViewController.h"


@implementation StatsViewController

@synthesize difficulty;
@synthesize section;
@synthesize navItem;
@synthesize operation;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [operations count];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)localSection {
    
    //varför blir det här en warning?
    return [operations objectAtIndex:localSection];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    difficulty = indexPath.row+1;
    
    section = indexPath.section;
    
    float value = [[[Singleton sharedSingleton] sharedPrefs] floatForKey:[NSString stringWithFormat:@"%@%i", [operations objectAtIndex:section], difficulty]];
    
    NSString *highscore;
    
    if (value == 0) {
        highscore = @"None";
    }
    else {
        float time = [[[Singleton sharedSingleton] sharedPrefs] floatForKey:[NSString stringWithFormat:@"%@%i", [operations objectAtIndex:section], difficulty]];
        
        highscore = [NSString stringWithFormat:@"%.2f s", time];
    }
    
    NSString *cellID = [operations objectAtIndex:section];
    
    StatsTableCellController *cell = (StatsTableCellController *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) 
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"StatsTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    } 
    
    cell.titleLabel.text = [NSString stringWithFormat:@"Level %i", difficulty];
    cell.descriptionLabel.text = @"Fastest 10/10";
    
    
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
    
        
    NSLog(@"%@%i",name, stars);
    
    return cell;
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [navItem setTitle:[NSString stringWithFormat:@"%@",operation]];
    
    operations = [[NSMutableArray alloc] init];
    
    //För att lägga till ämnen, lägg till här och gör en ny segue på storyborden med identifyer samma
    
    [operations addObject:@"Addition"];
    [operations addObject:@"Subtraction"];
    [operations addObject:@"Multiplication"];
    [operations addObject:@"Division"];
    [operations addObject:@"Percent"];
    [operations addObject:@"Fratction"];
    [operations addObject:@"Equations"];
    
    [[self.navigationController navigationBar] setHidden:YES];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    return cell;
}
 
 */

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
