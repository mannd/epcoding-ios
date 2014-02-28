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

@property (strong, nonatomic) NSMutableArray *primaryCodes;
@property (strong, nonatomic) NSMutableArray *secondaryCodes;
@property (strong, nonatomic) NSMutableArray *disabledCodes;
@property BOOL disablePrimaryCodes;
@property BOOL ignoreNoSecondaryCodesSelected;

@property (weak, nonatomic) IBOutlet UITableView *codeTableView;

@end
