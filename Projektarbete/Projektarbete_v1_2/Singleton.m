//
//  Singleton.m
//  Simple Science
//
//  Copyright (c) 2013 Jonas Dahl & Philip Montalvo. All rights reserved.
//

#import "Singleton.h"

static Singleton *shared = NULL;

@implementation Singleton
@synthesize sharedPrefs;

- (id)init {
    if ( self = [super init] ) {
        self.sharedPrefs = [[NSUserDefaults alloc] init];
    }
    return self;
}

+ (Singleton *)sharedSingleton {
    {
        if ( !shared || shared == NULL ) {
            shared = [[Singleton alloc] init];
        }
        return shared;
    }
}


@end
