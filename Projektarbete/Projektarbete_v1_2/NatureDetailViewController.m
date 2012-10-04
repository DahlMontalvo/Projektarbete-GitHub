//
//  NatureDetailViewController.m
//  Projektarbete_v1_2
//
//  Created by Jonas Dahl on 2012-10-03.
//
//

#import "NatureDetailViewController.h"

@interface NatureDetailViewController ()

@end

@implementation NatureDetailViewController

@synthesize categoryID, subject, category, subjectLabel, questionLabel;

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
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    category = [[NSMutableArray alloc] init];
    
    category = [appDelegate getCategoryWithID:categoryID];
    
    NSLog(@"CategoryID: %i", categoryID);
    
    subjectLabel.text = [NSString stringWithFormat:@"%@: %@", subject, [category objectAtIndex:0]];
    
    questionLabel.text = [appDelegate getQuestionInCategory:categoryID];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return 0;
}


- (void)viewDidUnload {
    [self setSubjectLabel:nil];
    [self setQuestionLabel:nil];
    [super viewDidUnload];
}
- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
