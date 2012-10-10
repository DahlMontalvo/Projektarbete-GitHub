//
//  AboutViewController.m
//  Projektarbete_v1_2
//
//  Created by Philip Montalvo on 2012-07-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AboutViewController.h"

@implementation AboutViewController
@synthesize delegate;
@synthesize doneButton, syncButton, errorParsing, elementValue, articles, currentElement, item, rssParser, currentPart, categoryChanges, questionChanges, answerChanges, a;
@synthesize lightView, activityIndicatior;
-(IBAction)done:(id)sender {
    [self.delegate AboutViewControllerDidDone:self];
}


- (IBAction)emailPressed:(id)sender {
	MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
	mailController.mailComposeDelegate = self;
    NSArray *toRecipients = [NSArray arrayWithObject:@"VårSupportEmail"];
	[mailController setToRecipients:toRecipients];
	[mailController setSubject:@"Simple Science Feedback"];
	[mailController setMessageBody:@"Enter text here." isHTML:NO];
	[self presentModalViewController:mailController animated:YES];

}

- (void)mailComposeController:(MFMailComposeViewController*)mailController didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self becomeFirstResponder];
	[self dismissModalViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad

{
    [lightView setHidden:YES];
    [activityIndicatior setHidden:YES];
    
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    [lightView setHidden:YES];
    [activityIndicatior setHidden:YES];
}


- (void)viewDidUnload
{
    [self setSyncButton:nil];
    [self setLightView:nil];
    [self setActivityIndicatior:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)syncButtonPressed:(id)sender {
    //gör saker oklickbara
    [lightView setHidden:NO];
    [activityIndicatior setHidden:NO];
    [activityIndicatior startAnimating];
    NSLog(@"Visa activity");
    
    //Synka hela databasen
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDate *oldestUpdateDate = [appDelegate getLastSyncDate];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"YYYY-mm-dd_HH:mm:ss"];

    NSString *formattedDate = [format stringFromDate:oldestUpdateDate];
    
    NSString *url = [NSString stringWithFormat:@"http://ss.jdahl.se/getChanges.php?sinceDate=%@", formattedDate];
    
    //
    //I url ligger den URL vi ska accessa för att få XMLfilen med ändringarna!
    //
    
    NSString *agentString = @"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_6; en-us) AppleWebKit/525.27.1 (KHTML, like Gecko) Version/3.2.1 Safari/525.27.1";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                    [NSURL URLWithString:url]];
    [request setValue:agentString forHTTPHeaderField:@"User-Agent"];
    
    NSData *xmlFile = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    errorParsing = NO;
    
    rssParser = [[NSXMLParser alloc] initWithData:xmlFile];
    
    [rssParser setDelegate:self];
    
    // You may need to turn some of these on depending on the type of XML file you are parsing
    [rssParser setShouldProcessNamespaces:NO];
    [rssParser setShouldReportNamespacePrefixes:NO];
    [rssParser setShouldResolveExternalEntities:NO];
    
    [rssParser parse];
    
}

- (void)parserDidStartDocument:(NSXMLParser *)parser{
    NSLog(@"File found and parsing started");
    a = 0;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    
    NSString *errorString = [NSString stringWithFormat:@"Error code %i", [parseError code]];
    NSLog(@"Error parsing XML: %@", errorString);
    
    errorParsing = YES;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    currentElement = [elementName copy];
    elementValue = [[NSMutableString alloc] init];
    NSLog(@"<%@>", currentElement);
    if ([currentElement isEqualToString:@"categories"]) {
        currentPart = @"categories";
        NSLog(@"Här börjar kategoriedelen");
    }
    else if ([currentElement isEqualToString:@"questions"]) {
        currentPart = @"questions";
        NSLog(@"Här börjar frågedelen");
    }
    else if ([currentElement isEqualToString:@"answers"]) {
        currentPart = @"answers";
        NSLog(@"Här börjar svarsdelen");
    }
    else {
        if ([currentElement isEqualToString:@"entry"]) {
            a++;
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:currentElement]) {
        
    }
    if ([elementName isEqualToString:@"entry"]) {
        NSLog(@"Avsluta tidigare element");
    }
    NSLog(@"</%@>", elementName);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    [elementValue appendString:string];
    NSLog(@"%@", elementValue);
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    if (errorParsing == NO) {
        
        NSLog(@"XML processing done!");
        [lightView setHidden:YES];
        [activityIndicatior setHidden:YES];
        [activityIndicatior stopAnimating];
        
        //Dahl du vet bäst hur man tar fram antal nya frågor.
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Sync Done"
                                                          message:@"Added X New Questions!"
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        
        NSLog(@"Found changes: %i", a);
    } else {
        [lightView setHidden:YES];
        [activityIndicatior setHidden:YES];
        [activityIndicatior stopAnimating];
        NSLog(@"Error occurred during XML processing");
    }
    
}

@end
