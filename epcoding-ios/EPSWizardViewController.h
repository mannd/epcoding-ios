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

@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageContent;
@property (strong, nonatomic) NSArray *codes;

@end
