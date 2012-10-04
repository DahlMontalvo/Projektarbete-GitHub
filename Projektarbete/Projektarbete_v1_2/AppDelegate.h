//
//  AppDelegate.h
//  Projektarbete_v1_2
//
//  Created by Jonas Dahl on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    // DBvariabler
	NSString *databaseName;
	NSString *databasePath;
    
	// Frågorarray
	NSMutableArray *questions;
	NSMutableArray *categories;
}

@property (nonatomic, retain) NSMutableArray *questions;
@property (nonatomic, retain) NSMutableArray *categories;

@property (strong, nonatomic) UIWindow *window;

-(NSMutableArray *)getCategoryWithID:(int)ID;

@end
