//
//  EPSCodeSummaryTableViewController.h
//  EP Coding
//
//  Created by David Mann on 2/28/14.
//  Copyright (c) 2014 David Mann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPSCodeSummaryTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic)NSArray *selectedCodes;
@property (strong, nonatomic)NSArray *selectedPrimaryCodes;
@property (strong, nonatomic)NSArray *selectedSecondaryCodes;
@property BOOL ignoreNoSecondaryCodesSelected;

@end
