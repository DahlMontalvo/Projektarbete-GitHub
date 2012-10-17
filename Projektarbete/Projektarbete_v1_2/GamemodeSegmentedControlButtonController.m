//
//  GamemodeSegmentedControlButtonController.m
//  Projektarbete_v1_2
//
//  Created by Jonas Dahl on 2012-10-16.
//
//

#import "GamemodeSegmentedControlButtonController.h"

@implementation GamemodeSegmentedControlButtonController

@synthesize pressed;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setPressed:(BOOL)pressedArg {
    pressed = pressedArg;
    if ([[self titleForState:UIControlStateNormal] isEqualToString:@"Test"] && pressed == YES) {
        NSLog(@"Button 'Test' pressed");
    }
    if (pressed == YES) {
        [self setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@ButtonPressed.png", [self titleForState:UIControlStateNormal]]] forState:UIControlStateNormal];
    }
    else {
        [self setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@ButtonDepressed.png", [self titleForState:UIControlStateNormal]]] forState:UIControlStateNormal];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
