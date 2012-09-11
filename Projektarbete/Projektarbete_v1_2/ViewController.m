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
