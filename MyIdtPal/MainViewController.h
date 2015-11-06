//
//  MainViewController.h
//  MyIdtPal
//
//  Created by Jo Pu  on 11/5/15.
//  Copyright © 2015 Jos Factory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DonesTableViewController.h"

@interface MainViewController : UIViewController
@property (nonatomic) NSString *apiToken;
@property DonesTableViewController *donesTableViewController;
@property NSString *teamsUrl;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UITextField *doneTextField;

@end
