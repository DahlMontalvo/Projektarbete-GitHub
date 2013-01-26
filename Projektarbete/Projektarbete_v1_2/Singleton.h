//
//  Singleton.h
//  Simple Science
//
//  Copyright (c) 2013 Jonas Dahl & Philip Montalvo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Singleton : NSObject {
    NSUserDefaults *sharedPrefs;    
}

@property (nonatomic, retain) NSUserDefaults *sharedPrefs;
+ (Singleton *)sharedSingleton;

@end
