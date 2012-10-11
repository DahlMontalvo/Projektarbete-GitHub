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
    [self copyDatabaseIfNeeded];
	[self readQuestionsFromDatabase];
}

-(void) readQuestionsFromDatabase {
	// Setup the database object
	sqlite3 *database;
    
	// Init the animals Array
	categories = [[NSMutableArray alloc] init];
    
	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement = "SELECT * FROM categories WHERE deleted != 1";
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
		const char *sqlStatement = [[NSString stringWithFormat:@"SELECT * FROM categories WHERE id = %i AND deleted != 1", ID] UTF8String];
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

-(NSDate *)getLastSyncDate {
	sqlite3 *database;
    NSDate *lastDate = [NSDate date];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement = [@"SELECT MIN(categories.lastUpdated) AS r1, MIN(answers.lastUpdated) AS r2, MIN(questions.lastUpdated) AS r3 FROM categories, answers, questions" UTF8String];
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                for (int i = 0; i < 3; i++) {
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:sqlite3_column_int(compiledStatement, i)];
                    if ([lastDate timeIntervalSinceDate:date] > 0) {
                        lastDate = date;
                    }
                }
			}
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
        
	}
	sqlite3_close(database);
    
    NSLog(@"Datum: %@", [format stringFromDate:lastDate]);
    return lastDate;
    
}

-(void)updateQuestionWithId:(int)qId question:(NSString *)question parent:(int)parentCategory deleted:(int)deleted {
	sqlite3 *database;
    
    int now = [[NSDate date] timeIntervalSince1970];
    int found = 0;
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        const char *sqlStatement = [[NSString stringWithFormat:@"SELECT * FROM questions WHERE id = %i", qId] UTF8String];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                found++;
                NSLog(@"Hittades");
            }
        }
        // Release the compiled statement from memory
        //sqlite3_finalize(compiledStatement);
    }
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        if (found > 0) {
            
            NSLog(@"Uppdaterar");
            NSString *state = [NSString stringWithFormat:@"UPDATE questions SET parentCategory = %i, lastUpdated = %i, question = '%@', deleted = %i WHERE id = %i", parentCategory, now, question, deleted, qId];
            
            char *error;
            if ( sqlite3_exec(database, [state UTF8String], NULL, NULL, &error) == SQLITE_OK)
                NSLog(@"Funkade!");
            /*
             const char *newSqlStatement = [state UTF8String];
             sqlite3_stmt *newCompiledStatement;
             if (sqlite3_prepare_v2(database, newSqlStatement, -1, &newCompiledStatement, NULL) != SQLITE_OK) {
             NSLog(@"Fel!");
             }
             NSLog(@"%@", state);
             //sqlite3_finalize(newCompiledStatement);
             */
            
            
        }
        else {
            NSLog(@"Lägger till");
            NSString *state = [NSString stringWithFormat:@"INSERT INTO questions (parentCategory, lastUpdated, question, deleted, id) VALUES (%i, %i, '%@', %i, %i)", parentCategory, now, question, deleted, qId];
            
            char *error;
            if ( sqlite3_exec(database, [state UTF8String], NULL, NULL, &error) == SQLITE_OK)
                NSLog(@"Funkade!");
            
            /*
             const char *newSqlStatement = [state UTF8String];
             sqlite3_stmt *newCompiledStatement;
             sqlite3_prepare_v2(database, newSqlStatement, -1, &newCompiledStatement, NULL);
             //sqlite3_finalize(newCompiledStatement);
             NSLog(@"%@", state);
             */
        }
	}
	sqlite3_close(database);
    
}

-(void)updateAnswerWithId:(int)aId answer:(NSString *)answer parent:(int)parentQuestion correct:(int)correct deleted:(int)deleted {
	sqlite3 *database;
    
    int now = [[NSDate date] timeIntervalSince1970];
    int found = 0;
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        const char *sqlStatement = [[NSString stringWithFormat:@"SELECT * FROM questions WHERE id = %i", aId] UTF8String];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                found++;
            }
        }
    }
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        if (found > 0) {
            NSString *state = [NSString stringWithFormat:@"UPDATE answers SET questionId = %i, lastUpdated = %i, answer = '%@', deleted = %i, correct = %i WHERE id = %i", parentQuestion, now, answer, deleted, correct, aId];
            char *error;
            sqlite3_exec(database, [state UTF8String], NULL, NULL, &error);
        }
        else {
            NSString *state = [NSString stringWithFormat:@"INSERT INTO answers (questionId, lastUpdated, answer, deleted, id, correct) VALUES (%i, %i, '%@', %i, %i, %i)", parentQuestion, now, answer, deleted, aId, correct];
            char *error;
            sqlite3_exec(database, [state UTF8String], NULL, NULL, &error);
        }
	}
	sqlite3_close(database);
}

-(void)updateCategoryWithId:(int)cId name:(NSString *)name parent:(NSString *)parent deleted:(int)deleted {
	sqlite3 *database;
    
    int now = [[NSDate date] timeIntervalSince1970];
    int found = 0;
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        const char *sqlStatement = [[NSString stringWithFormat:@"SELECT * FROM categories WHERE id = %i", cId] UTF8String];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                found++;
            }
        }
    }
    NSLog(@"found: %i",found);
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        if (found > 0) {
            NSString *state = [NSString stringWithFormat:@"UPDATE categories SET parent = '%@', lastUpdated = %i, name = '%@', deleted = %i WHERE id = %i", parent, now, name, deleted, cId];
            char *error;
            if (sqlite3_exec(database, [state UTF8String], NULL, NULL, &error) == SQLITE_OK) {
                NSLog(@"Funka! %@", state);
            }
        }
        else {
            NSString *state = [NSString stringWithFormat:@"INSERT INTO categories (parent, lastUpdated, name, deleted, id) VALUES ('%@', %i, '%@', %i, %i)", parent, now, name, deleted, cId];
            char *error;
            
            if (sqlite3_exec(database, [state UTF8String], NULL, NULL, &error) == SQLITE_OK) {
                NSLog(@"Funka med! %@", state);
            }
            else
                NSLog(@"Fel! %@", state);

        }
	}
	sqlite3_close(database);
    
    [self readQuestionsFromDatabase];
}


-(NSMutableArray *) getQuestionInCategory:(int)ID {
	sqlite3 *database;
    NSMutableArray *question = [[NSMutableArray alloc] init];
    BOOL found = NO;
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		const char *sqlStatement = [[NSString stringWithFormat:@"SELECT * FROM questions WHERE parentCategory = %i AND deleted != 1 ORDER BY id ASC", ID] UTF8String];
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				NSNumber *qID = [NSNumber numberWithInt:sqlite3_column_int(compiledStatement, 0)];
				NSString *questionStr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
                
                /* HÄMTA SVAREN */
                //Rätt svar alltid först i arrayen
                const char *sqlStatement3 = [[NSString stringWithFormat:@"SELECT * FROM answers WHERE questionId = %i AND deleted != 1 AND correct = 1", [qID intValue]] UTF8String];
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
                
                const char *sqlStatement2 = [[NSString stringWithFormat:@"SELECT * FROM answers WHERE questionId == %i AND deleted != 1 AND correct == 0 LIMIT 3", [qID intValue]] UTF8String];
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
                
                const char *sqlStatement4 = [[NSString stringWithFormat:@"SELECT * FROM answers WHERE questionId != %i AND deleted != 1 LIMIT 3", [qID intValue]] UTF8String];
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

- (void) copyDatabaseIfNeeded {
    databaseName = @"Database.sql";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *dbPath = [self getDBPath];
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    databasePath = dbPath;
    
    if(!success) {
        
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        
        if (!success)
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
    
    NSLog(@"path: %@", dbPath);
}

- (NSString *) getDBPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:databaseName];
}

@end
