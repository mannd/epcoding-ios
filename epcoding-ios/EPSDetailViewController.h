//
//  EPSDetailViewController.h
//  epcoding-ios
//
//  Created by David Mann on 10/14/13.
//  Copyright (c) 2013 David Mann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPSDetailViewController : UIViewController <UISplitViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) NSMutableArray *primaryCodes;
@property (weak, nonatomic) NSMutableArray *secondaryCodes;
@property (weak, nonatomic) NSMutableArray *disabledCodes;
@property BOOL disablePrimaryCodes;
@property BOOL ignoreNoSecondaryCodesSelected;

@property (weak, nonatomic) IBOutlet UITableView *codeTableView;

@end
