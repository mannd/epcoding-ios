//
//  EPSSearchTableViewController.m
//  EP Coding
//
//  Created by David Mann on 4/16/14.
//  Copyright (c) 2014 David Mann. All rights reserved.
//

#import "EPSSearchTableViewController.h"
#import "EPSCodes.h"
#import "EPSCode.h"

@interface EPSSearchTableViewController ()

@end

@implementation EPSSearchTableViewController
{
    NSInteger cellHeight;

}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Search Codes"];
    self.codes = [EPSCodes allCodesSorted];
    // only show "clean" codes during search
    [EPSCodes clearMultipliersAndModifiers:self.codes];
    cellHeight = 65;
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.obscuresBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;


}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController setToolbarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
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
    static NSString *searchCellIdentifier = @"searchCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:searchCellIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    EPSCode *code = nil;
    
    if (self.searchController.active) {
        code = [self.searchResults objectAtIndex:indexPath.row];
    }
    else {
        code = [self.codes objectAtIndex:row];
    }
    cell.detailTextLabel.text = [code unformattedCodeDescription];
    cell.textLabel.text = [code unformattedCodeNumber];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    //cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    // default gray color looks bad when background color is red or orange
    if (@available(iOS 13.0, *)) {
        cell.detailTextLabel.textColor = [UIColor labelColor];
    } else {
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    cell.detailTextLabel.numberOfLines = 0;
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
