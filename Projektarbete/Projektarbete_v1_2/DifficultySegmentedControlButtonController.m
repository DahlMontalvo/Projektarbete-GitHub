//
//  DifficultySegmentedControlButtonController.m
//  Projektarbete_v1_2
//
//  Created by Jonas Dahl on 2012-10-16.
//
//

#import "DifficultySegmentedControlButtonController.h"

@implementation DifficultySegmentedControlButtonController

@synthesize pressed;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setPressed:(BOOL)pressedArg {
    pressed = pressedArg;
    if ([[self titleForState:UIControlStateNormal] isEqualToString:@"1"] && pressed == YES) {
        NSLog(@"Button 1 pressed");
    }
    if (pressed == YES) {
        [self setBackgroundColor:[UIColor blueColor]];
    }
    else {
        [self setBackgroundColor:[UIColor redColor]];
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
