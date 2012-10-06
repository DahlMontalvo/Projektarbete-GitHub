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
        
        int random = 0;
        NSMutableArray *buttons = [[NSMutableArray alloc] initWithObjects:buttonOne, buttonTwo, buttonThree, buttonFour, nil];
        NSMutableArray *randoms = [[NSMutableArray alloc] init];
        //Random ordning
        for (int i = 0; i <= 3; i++) {
            NSLog(@"Hit");
            BOOL continueLoop = YES;
            while (continueLoop) {
                NSLog(@"Dit");
                int temp = arc4random() % 4;
                BOOL found = NO;
                for (int a = 0; a <= i-1; a++) {
                    NSLog(@"%i, %i, %i", a, [[randoms objectAtIndex:a] intValue], temp);
                    if ([[randoms objectAtIndex:a] intValue] == temp) {
                        found = YES;
                        NSLog(@"Found");
                    }
                    NSLog(@"Lit");
                }
                if (found == NO) {
                    NSLog(@"Skit");
                    random = temp;
                    continueLoop = NO;
                }
            }
            NSString *correct = @"";
            if ([[[[question objectAtIndex:2] objectAtIndex:i] objectAtIndex:2] intValue] == 1)
                correct = @" (rätt)";
            
            NSString *btnString = [NSString stringWithFormat:@"%@%@", [[[question objectAtIndex:2] objectAtIndex:i] objectAtIndex:0], correct];
            [[buttons objectAtIndex:random] setTitle:btnString forState:UIControlStateNormal];
            [randoms addObject:[NSNumber numberWithInt:random]];
        }
        /*
        [buttonOne setTitle:[[[question objectAtIndex:2] objectAtIndex:0] objectAtIndex:0] forState:UIControlStateNormal];
        [buttonTwo setTitle:[[[question objectAtIndex:2] objectAtIndex:1] objectAtIndex:0] forState:UIControlStateNormal];
        [buttonThree setTitle:[[[question objectAtIndex:2] objectAtIndex:2] objectAtIndex:0] forState:UIControlStateNormal];
        [buttonFour setTitle:[[[question objectAtIndex:2] objectAtIndex:3] objectAtIndex:0] forState:UIControlStateNormal];
         */
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
