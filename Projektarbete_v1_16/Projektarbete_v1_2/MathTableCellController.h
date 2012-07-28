//
//  MathTableCellController.h
//  Projektarbete_v1_2
//
//  Created by Philip Montalvo on 2012-07-25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MathTableCellController : UITableViewCell


@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (retain , nonatomic) IBOutlet UIImageView *imageView;

@end
