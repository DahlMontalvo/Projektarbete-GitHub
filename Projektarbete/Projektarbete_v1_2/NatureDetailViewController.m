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

@synthesize categoryID, subject, category, subjectLabel, questionLabel, buttonOne, buttonTwo, buttonThree, buttonFour;

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
    
    NSMutableArray *question = [appDelegate getQuestionInCategory:categoryID];
    if (question != nil) {
        questionLabel.text = [question objectAtIndex:0];
        
        [buttonOne setTitle:[[[question objectAtIndex:2] objectAtIndex:0] objectAtIndex:0] forState:UIControlStateNormal];
        [buttonTwo setTitle:[[[question objectAtIndex:2] objectAtIndex:1] objectAtIndex:0] forState:UIControlStateNormal];
        [buttonThree setTitle:[[[question objectAtIndex:2] objectAtIndex:2] objectAtIndex:0] forState:UIControlStateNormal];
        [buttonFour setTitle:[[[question objectAtIndex:2] objectAtIndex:3] objectAtIndex:0] forState:UIControlStateNormal];
    }
    else {
        questionLabel.text = @"Ingen fråga hittad.";
        
        [buttonOne setHidden:YES];
        [buttonTwo setHidden:YES];
        [buttonThree setHidden:YES];
        [buttonFour setHidden:YES];
    }
    
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
    [self setButtonOne:nil];
    [self setButtonTwo:nil];
    [self setButtonThree:nil];
    [self setButtonFour:nil];
    [super viewDidUnload];
}
- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
