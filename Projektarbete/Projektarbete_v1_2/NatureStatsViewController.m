//
//  NatureStatsViewController.m
//  Simple Science
//
//  Copyright (c) 2013 Jonas Dahl & Philip Montalvo. All rights reserved.
//

#import "NatureStatsViewController.h"

@interface NatureStatsViewController ()

@end

@implementation NatureStatsViewController

@synthesize subject, categories, titleLabel, tableView;

#pragma mark - Initialization

#pragma mark - View management
- (void)viewWillAppear:(BOOL)animated {
    
    tableView.backgroundColor = [UIColor clearColor];
    tableView.opaque = NO;
    tableView.backgroundView = nil;
    tableView.separatorColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [super viewWillAppear:animated];
    
    [titleLabel setText:[NSString stringWithFormat:@"%@ Stats", subject]];
    
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

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setTitleLabel:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [categories count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)localTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0){
        NSString *cellID = @"MixedCell";
        StatsTableCellController *cell = (StatsTableCellController *)[localTableView dequeueReusableCellWithIdentifier:cellID];
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
            int time = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:[NSString stringWithFormat:@"NatureCategory%@MixedTime",subject]];
            
            highscore = [NSString stringWithFormat:@"%i", time];
        }
        
        cell.valueLabel.text = highscore;
        return cell;
    }
    else {
        NSString *cellID = [[categories objectAtIndex:indexPath.row-1] objectAtIndex:0];
        StatsTableCellController *cell = (StatsTableCellController *)[localTableView dequeueReusableCellWithIdentifier:cellID];
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
            int time = [[[Singleton sharedSingleton] sharedPrefs] integerForKey:[NSString stringWithFormat:@"NatureCategory%iTime", [[[categories objectAtIndex:indexPath.row-1] objectAtIndex:2] intValue]]];
            
            highscore = [NSString stringWithFormat:@"%i", time];
        }
        NSLog(@"%@", [NSString stringWithFormat:@"NatureCategory%iTime", [[[categories objectAtIndex:indexPath.row-1] objectAtIndex:2] intValue]]);
        
        cell.valueLabel.text = highscore;
        
        return cell;
    }
}

- (void)tableView:(UITableView *)localTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [localTableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Others
- (IBAction)pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
