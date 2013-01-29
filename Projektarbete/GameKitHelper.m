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
            }
            if (error != nil) {
                [[[Singleton sharedSingleton] sharedPrefs] setInteger:scoreScore forKey:@"StoredScore"];
                NSLog(@"Error");
            }
        }];
        
    }
}

+ (void) reportAchievementIdentifier: (NSString*) identifier percentComplete: (float) percent
{
    //Hämta detta acheivment
    [GKAchievement loadAchievementsWithCompletionHandler: ^(NSArray *scores, NSError *error)
    {
        if (error == nil) {
            for (GKAchievement* achievement in scores) {
                if (achievement.completed == NO && [achievement.identifier isEqualToString:identifier]) {
                    
                    GKAchievement *achievement2 = [[GKAchievement alloc] initWithIdentifier:identifier];
                    achievement2.showsCompletionBanner = YES;
                    if (achievement2) {
                        achievement2.percentComplete = percent;
                        [achievement2 reportAchievementWithCompletionHandler:^(NSError *error)
                         {
                             if (error != nil)
                             {
                                 NSLog(@"Error in reporting achievements: %@", error);
                             }
                         }];
                    }
                    
                }
            }
        }
     
    }];
}

@end