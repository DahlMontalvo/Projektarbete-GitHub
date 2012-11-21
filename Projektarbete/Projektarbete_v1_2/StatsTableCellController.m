//
//  StatsTableCellController.m
//  Projektarbete_v1_2
//
//  Created by Jonas Dahl on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StatsTableCellController.h"

@implementation StatsTableCellController

@synthesize titleLabel;
@synthesize descriptionLabel;
@synthesize valueLabel;
@synthesize starsImage;

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
