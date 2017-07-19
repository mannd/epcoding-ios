//
//  ICD10TableViewController.h
//  EP Coding
//
//  Created by David Mann on 7/19/17.
//  Copyright © 2017 David Mann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ICD10TableViewController : UITableViewController

@property (strong, nonatomic) UISearchController *searchController;

@property (strong, nonatomic) NSArray *codes;
@property (strong, nonatomic) NSArray *searchResults;

@end
