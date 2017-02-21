//
//  EPSWizardViewController.h
//  EP Coding
//
//  Created by David Mann on 4/18/14.
//  Copyright (c) 2014 David Mann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EPSWizardContentViewController.h"


@interface EPSWizardViewController : UIViewController
    <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageContent;
@property (strong, nonatomic) NSArray *codes;
@property (strong, nonatomic) NSArray *codeNumbers;
@property (strong, nonatomic) NSArray *codeArrays;
@property (strong, nonatomic) NSMutableArray *selectedCodes;
@property (strong, nonatomic) EPSSedationCode *sedationCode;


@property SedationStatus sedationStatus;
@property NSInteger sedationTime;
@property BOOL sameMDPerformsSedation;
@property BOOL patientOver5YearsOld;
@property BOOL noSedationAdministered;

@end
