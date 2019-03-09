//
//  EPSWizardContentViewController.h
//  EP Coding
//
//  Created by David Mann on 4/18/14.
//  Copyright (c) 2014 David Mann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EPSCode.h"
#import "EPSSedationCode.h"
#import "EPSSedationViewController.h"
#import "EPSModifierTableViewController.h"

@interface EPSWizardContentViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate,
sendDataProtocol, sendModifiersProtocol>

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UITableView *codeTableView;
@property NSUInteger pageIndex;
@property (strong, nonatomic) NSString *titleText;
@property (strong, nonatomic) NSString *contentText;
@property (strong, nonatomic) NSArray *codes;
@property (strong, nonatomic) NSArray *allCodes;

@property (strong, nonatomic) NSMutableArray *sedationCodes;
@property (strong, nonatomic) NSDate *startSedationDate;
@property (strong, nonatomic) NSDate *endSedationDate;

@property SedationStatus sedationStatus;
@property NSInteger sedationTime;
@property BOOL sameMDPerformsSedation;
@property BOOL patientOver5YearsOld;

@end
