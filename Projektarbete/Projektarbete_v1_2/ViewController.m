//
//  ViewController.m
//  Projektarbete_v1_2
//
//  Created by Jonas Dahl on 9/11/12.
//
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize Back;
@synthesize tableView;

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
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MathFirstBG.png"]];
    
    self.tableView.backgroundView = imageView;
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setBack:nil];
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
@end
