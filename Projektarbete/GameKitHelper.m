//
//  GameKitHelper.h
//  Simple Science
//
//  Copyright (c) 2013 Jonas Dahl & Philip Montalvo. All rights reserved.
//

#import "GameKitHelper.h"

@interface GameKitHelper ()
<GKGameCenterControllerDelegate> {
    BOOL _gameCenterFeaturesEnabled;
}
@end

@implementation GameKitHelper

@synthesize achievementsDictionary;

#pragma mark Property setters

-(void) setLastError:(NSError*)error {
    _lastError = [error copy];
    if (_lastError) {
        NSLog(@"GameKitHelper ERROR: %@", [[_lastError userInfo]
                                           description]);
    }
}

#pragma mark UIViewController stuff

-(UIViewController*) getRootViewController {
    return [UIApplication
            sharedApplication].keyWindow.rootViewController;
}

-(void)presentViewController:(UIViewController*)vc {
    UIViewController* rootVC = [self getRootViewController];
    [rootVC presentViewController:vc animated:YES
                       completion:nil];
}

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
    
}

#pragma mark Singleton stuff

+(id) sharedGameKitHelper {
    static GameKitHelper *sharedGameKitHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGameKitHelper =
        [[GameKitHelper alloc] init];
    });
    return sharedGameKitHelper;
}

#pragma mark Player Authentication

-(void) authenticateLocalPlayer {
    NSLog(@"kallad");
    GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler =
    ^(UIViewController *viewController,
      NSError *error) {
        
        [self setLastError:error];

        if (localPlayer.authenticated) {
            _gameCenterFeaturesEnabled = YES;
        } else if(viewController) {
            [self presentViewController:viewController];
        } else {
            _gameCenterFeaturesEnabled = NO;
        }
    };
    
}

- (void) submitScore:(int64_t)scoreScore category:(NSString*) category
{
    GKScore* gkScore = [[GKScore alloc] initWithCategory:category];
    gkScore.value = (int64_t)scoreScore;
    
    GKScore *scoreReporter = [[GKScore alloc] initWithCategory:category];
    scoreReporter.value = scoreScore;
    scoreReporter.context = 0;
    
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        
    }];
}

+(void) submitAndAddScore:(int64_t)scoreScore {
    
    NSLog(@"kallas");
    
    GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
    NSArray *ids = [[NSArray alloc] initWithObjects:[localPlayer playerID], nil];
    GKLeaderboard *query = [[GKLeaderboard alloc] initWithPlayerIDs:ids];
    query.timeScope = GKLeaderboardTimeScopeAllTime;
    query.category = @"totalScore";
    if (query != nil) {
        
        [query loadScoresWithCompletionHandler: ^(NSArray *scores, NSError *error) {
            if (scores != nil) {
                NSLog(@"score: %@", scores);
                GKScore *score = [scores objectAtIndex:0];
                int64_t scoreVal = (int64_t)[score value];
                
                int64_t submitScore = scoreVal+scoreScore+[[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"StoredScore"];
                NSLog(@"submitscore: %i, %i", (int)submitScore, (int)scoreVal);
                
                [[GameKitHelper sharedGameKitHelper] submitScore:submitScore category:@"totalScore"];
                [[GameKitHelper sharedGameKitHelper] reportAchievementIdentifier:@"hundredk_and_counting" percentComplete:((float)submitScore/(float)100000)*100.0+0.5];
                [[GameKitHelper sharedGameKitHelper] reportAchievementIdentifier:@"fivehundredk_and_counting" percentComplete:((float)submitScore/(float)500000)*100.0+0.5];
                [[GameKitHelper sharedGameKitHelper] reportAchievementIdentifier:@"one_million" percentComplete:((float)submitScore/(float)1000000)*100.0+0.5];
            }
            else {
                NSLog(@"Ny user");
                int64_t submitScore = scoreScore+[[[Singleton sharedSingleton] sharedPrefs] integerForKey:@"StoredScore"];
                NSLog(@"submitscore: %i", (int)submitScore);
                
                [[GameKitHelper sharedGameKitHelper] submitScore:submitScore category:@"totalScore"];
                [[GameKitHelper sharedGameKitHelper] reportAchievementIdentifier:@"hundredk_and_counting" percentComplete:((float)submitScore/(float)100000)*100.0+0.5];
                [[GameKitHelper sharedGameKitHelper] reportAchievementIdentifier:@"fivehundredk_and_counting" percentComplete:((float)submitScore/(float)500000)*100.0+0.5];
                [[GameKitHelper sharedGameKitHelper] reportAchievementIdentifier:@"one_million" percentComplete:((float)submitScore/(float)1000000)*100.0+0.5];
            }
            if (error != nil) {
                [[[Singleton sharedSingleton] sharedPrefs] setInteger:scoreScore forKey:@"StoredScore"];
                NSLog(@"Error");
            }
        }];
        
    }
    else {
        NSLog(@"Ny user");
    }
}

- (void) reportAchievementIdentifier: (NSString*) identifier percentComplete: (float) percent {
    //Hämta detta acheivement
    /*[GKAchievement loadAchievementsWithCompletionHandler: ^(NSArray *scores, NSError *error) {
        if (error == nil) {
            for (GKAchievement* achievement in scores) {
                if ([achievement.identifier isEqualToString:identifier] && achievement.completed != YES && [[[Singleton sharedSingleton] sharedPrefs] boolForKey:identifier] != YES) {
                    GKAchievement *achievement2 = [[GKAchievement alloc] initWithIdentifier:identifier];
                    if (achievement2) {
                        achievement2.showsCompletionBanner = YES;
                        achievement2.percentComplete = percent;
                        [achievement2 reportAchievementWithCompletionHandler:^(NSError *error) { }];
                        NSLog(@"1: %@", achievement);
                    }
                    [[[Singleton sharedSingleton] sharedPrefs] setBool:achievement.completed forKey:achievement.identifier];
                }
            }
        }
    }];
    [[[Singleton sharedSingleton] sharedPrefs] synchronize];
    if ([[[Singleton sharedSingleton] sharedPrefs] boolForKey:identifier] == NO) {
        GKAchievement *achievement2 = [[GKAchievement alloc] initWithIdentifier:identifier];
        if (achievement2) {
            achievement2.showsCompletionBanner = YES;
            achievement2.percentComplete = percent;
            [achievement2 reportAchievementWithCompletionHandler:^(NSError *error) { }];
            NSLog(@"2: %@, %i", achievement2, [[[Singleton sharedSingleton] sharedPrefs] boolForKey:identifier]);
        }
    }
     */
    achievementsDictionary = [[NSMutableDictionary alloc] init];
    
    for (id key in achievementsDictionary) {
        NSLog(@"key: %@, value: %@", key, [achievementsDictionary objectForKey:key]);
    }
    
    NSLog(@"Förbi");
    
    [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error) {
        if (error == nil) {
            for (GKAchievement* achievement in achievements) {
                [achievementsDictionary setObject:achievement forKey:achievement.identifier];
                NSLog(@"Ach: %@", achievement);
            }
        }
        GKAchievement *achievementFromBefore = [[[GameKitHelper sharedGameKitHelper] achievementsDictionary] objectForKey:identifier];
        if (achievementFromBefore.completed == NO && achievementFromBefore.percentComplete < 100) {
            GKAchievement *achievement = [[GKAchievement alloc] initWithIdentifier:identifier];
            if (achievement) {
                achievement.showsCompletionBanner = YES;
                achievement.percentComplete = percent;
                [achievement reportAchievementWithCompletionHandler:^(NSError *error) { }];
                NSLog(@"Added: %@", identifier);
            }
        }
    }];
}

@end