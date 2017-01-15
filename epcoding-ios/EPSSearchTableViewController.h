//
//  EPSSearchTableViewController.h
//  EP Coding
//
//  Created by David Mann on 4/16/14.
//  Copyright (c) 2014 David Mann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPSSearchTableViewController : UITableViewController <UISearchResultsUpdating, UISearchBarDelegate>

@property (strong, nonatomic) UISearchController *searchController;

@property (strong, nonatomic) NSArray *codes;
@property (strong, nonatomic) NSArray *searchResults;

@end
