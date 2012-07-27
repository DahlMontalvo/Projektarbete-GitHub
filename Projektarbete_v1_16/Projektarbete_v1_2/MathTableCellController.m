//
//  MathTableCellController.m
//  Projektarbete_v1_2
//
//  Created by Philip Montalvo on 2012-07-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MathTableCellController.h"

@implementation MathTableCellController

@synthesize titleLabel;
@synthesize valueLabel;
@synthesize imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
