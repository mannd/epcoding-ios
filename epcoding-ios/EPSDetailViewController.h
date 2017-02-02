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
@property (strong, nonatomic) NSMutableArray *sedationCodes;
@property (strong, nonatomic) NSSet *disabledCodesSet;
@property BOOL disablePrimaryCodes;
@property BOOL ignoreNoSecondaryCodesSelected;

@property (weak, nonatomic) IBOutlet UITableView *codeTableView;

@property NSInteger sedationTime;
@property BOOL sameMDPerformsSedation;
@property BOOL patientOver5YearsOld;

@property (strong, nonatomic) UIBarButtonItem *buttonSummarize;
@property (strong, nonatomic) UIBarButtonItem *buttonClear;
@property (strong, nonatomic) UIBarButtonItem *buttonSave;

@end
