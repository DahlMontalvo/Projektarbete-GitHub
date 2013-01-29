//
//  GameKitHelper.m
//  Simple Science
//
//  Copyright (c) 2013 Jonas Dahl & Philip Montalvo. All rights reserved.
//

#import <GameKit/GameKit.h>

@protocol GameKitHelperProtocol<NSObject>
-(void) onScoresSubmitted:(bool)success;
@end


@interface GameKitHelper : NSObject

@property (nonatomic, assign)
id<GameKitHelperProtocol> delegate;

@property (nonatomic, readonly) NSError* lastError;


+ (id) sharedGameKitHelper;
-(void) authenticateLocalPlayer;
-(void) submitScore:(int64_t)scoreScore category:(NSString*)category;
+(int64_t) getScoreInCategory;

@end