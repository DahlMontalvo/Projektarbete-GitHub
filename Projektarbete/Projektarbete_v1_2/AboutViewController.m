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
@synthesize doneButton, syncButton, errorParsing, questionsUpdated, elementValue, articles, currentElement, item, rssParser, currentPart, currentItem, categoryChanges, questionChanges, answerChanges, a;
@synthesize lightView, activityIndicatior;
-(IBAction)done:(id)sender {
    [self.delegate AboutViewControllerDidDone:self];
}


- (IBAction)emailPressed:(id)sender {
	MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
	mailController.mailComposeDelegate = self;
    NSArray *toRecipients = [NSArray arrayWithObject:@"feedback@dahlmontalvo.com"];
	[mailController setToRecipients:toRecipients];
	[mailController setSubject:@"Simple Science Feedback"];
	[mailController setMessageBody:@"" isHTML:NO];
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
    NSString *string = @"string med &aring; &auml; &ouml;";
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
    [lightView setHidden:NO];
    [activityIndicatior setHidden:NO];
    [activityIndicatior startAnimating];
    
    questionChanges = [[NSMutableArray alloc] init];
    categoryChanges = [[NSMutableArray alloc] init];
    answerChanges = [[NSMutableArray alloc] init];
    
    //Synka hela databasen
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDate *oldestUpdateDate = [appDelegate getLastSyncDate];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"YYYY-MM-dd_HH:mm:ss"];

    NSString *formattedDate = [format stringFromDate:oldestUpdateDate];
    
    
    NSString *url = [NSString stringWithFormat:@"http://ss.jdahl.se/getChanges.php?sinceDate=%@", formattedDate];
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

- (IBAction)likeButtonPressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://facebook.com/dahlmontalvoapps"]];
}

- (IBAction)feedBackFacebookButtonPressed:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://facebook.com/dahlmontalvoapps"]];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser{
    a = 0;
    questionsUpdated = 0;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    errorParsing = YES;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    currentElement = [elementName copy];
    elementValue = [[NSMutableString alloc] init];
    
    if ([currentElement isEqualToString:@"categories"])
        currentPart = @"categories";
    else if ([currentElement isEqualToString:@"questions"])
        currentPart = @"questions";
    else if ([currentElement isEqualToString:@"answers"])
        currentPart = @"answers";
    else {
        if ([currentElement isEqualToString:@"entry"]) {
            a++;
        }
        if ([currentElement isEqualToString:@"entry"] && [currentPart isEqualToString:@"questions"]) {
            questionsUpdated++;
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    NSString *val = [elementValue copy];
    if ([elementName isEqualToString:@"entry"]) {
        if ([currentPart isEqualToString:@"questions"]) {
        
        }
    }
    else {
        if ([currentPart isEqualToString:@"questions"]) {
            if ([elementName isEqualToString:@"id"]) {
                [questionChanges insertObject:[[NSMutableArray alloc] init] atIndex:questionsUpdated-1];
                [[questionChanges objectAtIndex:questionsUpdated-1] insertObject:[NSNumber numberWithInt:[elementValue intValue]] atIndex:0];
            }
            else if ([elementName isEqualToString:@"question"]) {
                val = [val stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                [[questionChanges objectAtIndex:questionsUpdated-1] insertObject:val atIndex:1];
            }
            else if ([elementName isEqualToString:@"parentCategory"]) {
                [[questionChanges objectAtIndex:questionsUpdated-1] insertObject:[NSNumber numberWithInt:[elementValue intValue]] atIndex:2];
            }
            else if ([elementName isEqualToString:@"lastUpdated"]) {
                val = [val stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                [[questionChanges objectAtIndex:questionsUpdated-1] insertObject:val atIndex:3];
            }
            else if ([elementName isEqualToString:@"deleted"]) {
                [[questionChanges objectAtIndex:questionsUpdated-1] insertObject:[NSNumber numberWithInt:[elementValue intValue]] atIndex:4];
            }
        }
        
        
        
        
        else if ([currentPart isEqualToString:@"categories"]) {
            if ([elementName isEqualToString:@"id"]) {
                [categoryChanges insertObject:[[NSMutableArray alloc] init] atIndex:[categoryChanges count]];
                [[categoryChanges objectAtIndex:[categoryChanges count]-1] insertObject:[NSNumber numberWithInt:[elementValue intValue]] atIndex:0];
            }
            else if ([elementName isEqualToString:@"name"]) {
                val = [val stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                [[categoryChanges objectAtIndex:[categoryChanges count]-1] insertObject:val atIndex:1];
            }
            else if ([elementName isEqualToString:@"parent"]) {
                val = [val stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                [[categoryChanges objectAtIndex:[categoryChanges count]-1] insertObject:val atIndex:2];
            }
            else if ([elementName isEqualToString:@"lastUpdated"]) {
                val = [val stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                [[categoryChanges objectAtIndex:[categoryChanges count]-1] insertObject:val atIndex:3];
            }
            else if ([elementName isEqualToString:@"deleted"]) {
                [[categoryChanges objectAtIndex:[categoryChanges count]-1] insertObject:[NSNumber numberWithInt:[elementValue intValue]] atIndex:4];
            }
        }
        
        
        
        
        else if ([currentPart isEqualToString:@"answers"]) {
            if ([elementName isEqualToString:@"id"]) {
                [answerChanges insertObject:[[NSMutableArray alloc] init] atIndex:[answerChanges count]];
                [[answerChanges objectAtIndex:[answerChanges count]-1] insertObject:[NSNumber numberWithInt:[elementValue intValue]] atIndex:0];
            }
            else if ([elementName isEqualToString:@"answer"]) {
                val = [val stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                [[answerChanges objectAtIndex:[answerChanges count]-1] insertObject:val atIndex:1];
            }
            else if ([elementName isEqualToString:@"questionId"]) {
                val = [val stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                [[answerChanges objectAtIndex:[answerChanges count]-1] insertObject:val atIndex:2];
            }
            else if ([elementName isEqualToString:@"correct"]) {
                [[answerChanges objectAtIndex:[answerChanges count]-1] insertObject:[NSNumber numberWithInt:[elementValue intValue]] atIndex:3];
            }
            else if ([elementName isEqualToString:@"lastUpdated"]) {
                val = [val stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                [[answerChanges objectAtIndex:[answerChanges count]-1] insertObject:val atIndex:4];
            }
            else if ([elementName isEqualToString:@"deleted"]) {
                [[answerChanges objectAtIndex:[answerChanges count]-1] insertObject:[NSNumber numberWithInt:[elementValue intValue]] atIndex:5];
            }
        }
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    [elementValue appendString:string];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    if (errorParsing == NO) {
    } else {
        [lightView setHidden:YES];
        [activityIndicatior setHidden:YES];
        [activityIndicatior stopAnimating];
    }
    
    NSString *messageText;
    if (questionsUpdated > 3) {
        messageText = [NSString stringWithFormat:@"%i questions changed/updated!", questionsUpdated];
    }
    else if (questionsUpdated == 3) {
        messageText = @"Three questions changed/updated!";
    }
    else if (questionsUpdated == 2) {
        messageText = @"Two questions changed/updated!";
    }
    else if (questionsUpdated == 1) {
        messageText = @"One question changed/updated!";
    }
    else {
        messageText = @"There was nothing to sync";
    }
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Sync Complete"
                                                      message:messageText
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    [message show];
    
    [lightView setHidden:YES];
    [activityIndicatior setHidden:YES];
    [activityIndicatior stopAnimating];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    for (int i = 0; i < [questionChanges count]; i++) {
        [appDelegate updateQuestionWithId:[[[questionChanges objectAtIndex:i] objectAtIndex:0] intValue] question:[[questionChanges objectAtIndex:i] objectAtIndex:1] parent:[[[questionChanges objectAtIndex:i] objectAtIndex:2] intValue] deleted:[[[questionChanges objectAtIndex:i] objectAtIndex:4] intValue]];
    }
    for (int i = 0; i < [answerChanges count]; i++) {
        [appDelegate updateAnswerWithId:[[[answerChanges objectAtIndex:i] objectAtIndex:0] intValue]
                                 answer:[[answerChanges objectAtIndex:i] objectAtIndex:1]
                                 parent:[[[answerChanges objectAtIndex:i] objectAtIndex:2] intValue]
                                correct:[[[answerChanges objectAtIndex:i] objectAtIndex:3] intValue]
                                deleted:[[[answerChanges objectAtIndex:i] objectAtIndex:5] intValue]];
    }
    for (int i = 0; i < [categoryChanges count]; i++) {
        [appDelegate updateCategoryWithId:[[[categoryChanges objectAtIndex:i] objectAtIndex:0] intValue]
                                     name:[[categoryChanges objectAtIndex:i] objectAtIndex:1]
                                   parent:[[categoryChanges objectAtIndex:i] objectAtIndex:2]
                                  deleted:[[[categoryChanges objectAtIndex:i] objectAtIndex:4] intValue]];
    }
    
    [appDelegate readQuestionsFromDatabase];
    
}

@end
