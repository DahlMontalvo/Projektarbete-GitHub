//
//  AppDelegate.h
//  Simple Science
//
//  Copyright (c) 2013 Jonas Dahl & Philip Montalvo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
	NSString *databaseName;
	NSString *databasePath;
	NSMutableArray *questions;
	NSMutableArray *categories;
}

@property (nonatomic, retain) NSMutableArray *questions;
@property (nonatomic, retain) NSMutableArray *categories;
@property (nonatomic) BOOL *kNOT_FIRST_LAUNCH;
@property (strong, nonatomic) UIWindow *window;

-(NSMutableArray *)getCategoryWithID:(int)ID;
-(NSMutableArray *) getQuestionInCategory:(int)ID withOutIds:(NSMutableArray *)noId;
-(NSMutableArray *) getQuestionInMainCategory:(NSString *)subject withOutIds:(NSMutableArray *)noId;
-(int)numbersOfQuestionsInCategory:(int)ID;
-(void)updateQuestionWithId:(int)qId question:(NSString *)question parent:(int)parentCategory deleted:(int)deleted;
-(void)updateAnswerWithId:(int)aId answer:(NSString *)answer parent:(int)parentQuestion correct:(int)correct deleted:(int)deleted;
-(void)updateCategoryWithId:(int)cId name:(NSString *)name parent:(NSString *)parent deleted:(int)deleted;
-(void)readCategoriesFromDatabase;
-(void)copyDatabaseIfNeeded;
-(NSString *)getDBPath;

@end
