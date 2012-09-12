//
//  ViewController.h
//  Projektarbete_v1_2
//
//  Created by Jonas Dahl on 9/11/12.
//
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *Back;
@property (nonatomic, retain)IBOutlet UITableView *tableView;
- (IBAction)Button:(id)sender;


@end
