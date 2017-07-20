//
//  ICD10TableViewController.m
//  EP Coding
//
//  Created by David Mann on 7/19/17.
//  Copyright © 2017 David Mann. All rights reserved.
//

#import "ICD10TableViewController.h"
#import "ICD10Code.h"
#import "ICD10Codes.h"

#define SECTION_COLOR UIColor.orangeColor

@interface ICD10TableViewController ()

@end

@implementation ICD10TableViewController
{
    NSInteger cellHeight;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self setTitle:@"ICD-10 Codes"];
    self.codes = [ICD10Codes allCodes];
    // only show "clean" codes during search
//    cellHeight = 65;
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    
    cellHeight = 70;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"fullDescription contains[c] %@ OR number contains %@", searchText, searchText];
    self.searchResults = [self.codes filteredArrayUsingPredicate:resultPredicate];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.active) {
        return [self.searchResults count];
        
    } else {
        return [self.codes count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *searchCellIdentifier = @"ICD10Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:searchCellIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    ICD10Code *code = nil;
    
    if (self.searchController.active) {
        code = [self.searchResults objectAtIndex:indexPath.row];
    }
    else {
        code = [self.codes objectAtIndex:row];
    }
    cell.detailTextLabel.text = [code fullDescription];
    cell.detailTextLabel.numberOfLines = 0;
    cell.textLabel.text = [code number];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    //cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    // default gray color looks bad when background color is red or orange
    cell.detailTextLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}


#pragma mark - UISearchController delegate

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    [self filterContentForSearchText:searchString scope:nil];
    [self.tableView reloadData];
}



@end
