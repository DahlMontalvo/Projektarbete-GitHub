//
//  AppDelegate.m
//  Projektarbete_v1_2
//
//  Created by Jonas Dahl on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize questions;
@synthesize categories;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [NSThread sleepForTimeInterval:1.0];
    
    UIApplication *app = [UIApplication sharedApplication];
    [app setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    // Override point for customization after application launch.
    return YES;
    
    [application setStatusBarHidden:YES];
}

-(void)applicationDidBecomeActive:(UIApplication *)application {
    // Setup some globals
	databaseName = @"Database.sql";
    
	// Get the path to the documents directory and append the databaseName
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
    
	// Execute the "checkAndCreateDatabase" function
	[self checkAndCreateDatabase];
    
	// Databas till array
	[self readQuestionsFromDatabase];
    NSLog(@"Hej nu är jag aktiv!");
}

-(void) checkAndCreateDatabase{
	// Check if the SQL database has already been saved to the users phone, if not then copy it over
	BOOL success;
    
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
	// Check if the database has already been created in the users filesystem
	success = [fileManager fileExistsAtPath:databasePath];
    
	// If the database already exists then return without doing anything
	if(success) return;
    
	// If not then proceed to copy the database from the application to the users filesystem
    
	// Get the path to the database in the application package
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
    
	// Copy the database from the package to the users filesystem
	[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
}

-(void) readQuestionsFromDatabase {
	// Setup the database object
	sqlite3 *database;
    
	// Init the animals Array
	categories = [[NSMutableArray alloc] init];
    
	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement = "SELECT * FROM categories";
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				// Read the data from the result row
				NSNumber *catID = [NSNumber numberWithInt:sqlite3_column_int(compiledStatement, 0)];
				NSString *category = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString *parent = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                
                NSMutableArray *cat = [[NSMutableArray alloc] initWithObjects:category, parent, catID, nil];
                
                [categories addObject:cat];
			}
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
        
	}
	sqlite3_close(database);
    
}

-(NSMutableArray *) getCategoryWithID:(int)ID {
	sqlite3 *database;
    NSMutableArray *category = [[NSMutableArray alloc] init];
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement = [[NSString stringWithFormat:@"SELECT * FROM categories WHERE id = %i", ID] UTF8String];
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				NSNumber *catID = [NSNumber numberWithInt:sqlite3_column_int(compiledStatement, 0)];
				NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                NSString *parent = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
                
                [category addObject:name];
                [category addObject:parent];
                [category addObject:catID];
			}
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
        
	}
	sqlite3_close(database);
    
    return category;
    
}

-(NSMutableArray *) getQuestionInCategory:(int)ID {
	sqlite3 *database;
    NSMutableArray *question = [[NSMutableArray alloc] init];
    BOOL found = NO;
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement = [[NSString stringWithFormat:@"SELECT * FROM questions WHERE parentCategory = %i", ID] UTF8String];
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				NSNumber *qID = [NSNumber numberWithInt:sqlite3_column_int(compiledStatement, 0)];
				NSString *questionStr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                
                /* HÄMTA SVAREN */
                //Rätt svar alltid först i arrayen
                const char *sqlStatement3 = [[NSString stringWithFormat:@"SELECT * FROM answers WHERE questionId = %i AND correct = 1", [qID intValue]] UTF8String];
                sqlite3_stmt *compiledStatement3;
                NSMutableArray *answers = [[NSMutableArray alloc] init];
                
                if(sqlite3_prepare_v2(database, sqlStatement3, -1, &compiledStatement3, NULL) == SQLITE_OK) {
                    while(sqlite3_step(compiledStatement3) == SQLITE_ROW) {
                        NSNumber *ansId = [NSNumber numberWithInt:sqlite3_column_int(compiledStatement, 0)];
                        NSString *answerStr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement3, 3)];
                        NSNumber *correct = [NSNumber numberWithInt:1];
                        
                        [answers addObject:[[NSMutableArray alloc] initWithObjects:answerStr, ansId, correct, nil]];
                        
                        found = YES;
                    }
                }
                sqlite3_finalize(compiledStatement3);
                
                //Tar fram tre fel svar
                int ansNum = 0;
                
                const char *sqlStatement2 = [[NSString stringWithFormat:@"SELECT * FROM answers WHERE questionId == %i AND correct == 0 LIMIT 3", [qID intValue]] UTF8String];
                sqlite3_stmt *compiledStatement2;
                if(sqlite3_prepare_v2(database, sqlStatement2, -1, &compiledStatement2, NULL) == SQLITE_OK) {
                    while(sqlite3_step(compiledStatement2) == SQLITE_ROW && ansNum <= 2) {
                        NSNumber *ansId = [NSNumber numberWithInt:sqlite3_column_int(compiledStatement2, 0)];
                        NSString *answerStr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement2, 3)];
                        NSNumber *correct = [NSNumber numberWithInt:0];
                        
                        [answers addObject:[[NSMutableArray alloc] initWithObjects:answerStr, ansId, correct, nil]];
                        
                        found = YES;
                        ansNum++;
                    }
                }
                sqlite3_finalize(compiledStatement2);
                
                const char *sqlStatement4 = [[NSString stringWithFormat:@"SELECT * FROM answers WHERE questionId != %i LIMIT 3", [qID intValue]] UTF8String];
                sqlite3_stmt *compiledStatement4;
                if(sqlite3_prepare_v2(database, sqlStatement4, -1, &compiledStatement4, NULL) == SQLITE_OK) {
                    while(sqlite3_step(compiledStatement4) == SQLITE_ROW && ansNum <= 2) {
                        NSNumber *ansId = [NSNumber numberWithInt:sqlite3_column_int(compiledStatement4, 0)];
                        NSString *answerStr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement4, 3)];
                        NSNumber *correct = [NSNumber numberWithInt:0];
                        
                        [answers addObject:[[NSMutableArray alloc] initWithObjects:answerStr, ansId, correct, nil]];
                        
                        found = YES;
                        ansNum++;
                    }
                }
                
                sqlite3_finalize(compiledStatement4);
                
                question = [[NSMutableArray alloc] initWithObjects:questionStr, qID, answers, nil];
			}
		}
		sqlite3_finalize(compiledStatement);
	}
	sqlite3_close(database);
    if (found)
        return question;
    else
        return nil;
    
}

							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
