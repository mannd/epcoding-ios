//
//  EPSWizardContentViewController.h
//  EP Coding
//
//  Created by David Mann on 4/18/14.
//  Copyright (c) 2014 David Mann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPSWizardContentViewController : UIViewController
    <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UITableView *codeTableView;
@property NSUInteger pageIndex;
@property (strong, nonatomic) NSString *titleText;
@property (strong, nonatomic) NSString *contentText;
@property (strong, nonatomic) NSArray *codes;

@end