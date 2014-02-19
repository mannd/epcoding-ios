//
//  EPSMasterViewController.h
//  epcoding-ios
//
//  Created by David Mann on 10/14/13.
//  Copyright (c) 2013 David Mann. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EPSDetailViewController;

@interface EPSMasterViewController : UITableViewController

@property (strong, nonatomic) EPSDetailViewController *detailViewController;

@property (strong, nonatomic) NSArray *procedureTypes;

@end
