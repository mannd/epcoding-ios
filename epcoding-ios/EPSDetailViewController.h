//
//  EPSDetailViewController.h
//  epcoding-ios
//
//  Created by David Mann on 10/14/13.
//  Copyright (c) 2013 David Mann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPSDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) NSArray *primaryCodes;
@property (strong, nonatomic) NSArray *secondaryCodes;
@property (strong, nonatomic) NSSet *disabledCodesSet;
@property BOOL disablePrimaryCodes;
@property BOOL ignoreNoSecondaryCodesSelected;

@property (weak, nonatomic) IBOutlet UITableView *codeTableView;

@property NSInteger sedationTime;
@property BOOL sameMDPerformsSedation;
@property BOOL patientOver5YearsOld;

@end
