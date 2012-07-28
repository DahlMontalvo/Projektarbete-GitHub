//
//  Singleton.h
//  alarm1
//
//  Created by Philip Montalvo on 2012-02-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Singleton : NSObject {

    NSUserDefaults *sharedPrefs;    
}

@property (nonatomic, retain) NSUserDefaults *sharedPrefs;


+ (Singleton *)sharedSingleton;
    

@end
