//
//  MathTableCellController.h
//  Simple Science
//
//  Copyright (c) 2013 Jonas Dahl & Philip Montalvo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MathTableCellController : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (retain , nonatomic) IBOutlet UIImageView *imageView;

@end
