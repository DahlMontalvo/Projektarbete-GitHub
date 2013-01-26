//
//  GameModeSegmentedControlButtonController.m
//  Simple Science
//
//  Copyright (c) 2013 Jonas Dahl & Philip Montalvo. All rights reserved.
//

#import "GamemodeSegmentedControlButtonController.h"

@implementation GamemodeSegmentedControlButtonController

@synthesize pressed;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (void) setPressed:(BOOL)pressedArg {
    pressed = pressedArg;
    if (pressed == YES) {
        [self setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@ButtonPressed.png", [self titleForState:UIControlStateNormal]]] forState:UIControlStateNormal];
    }
    else {
        [self setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@ButtonDepressed.png", [self titleForState:UIControlStateNormal]]] forState:UIControlStateNormal];
    }
}

@end
