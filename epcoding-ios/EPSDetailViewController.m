//
//  EPSDetailViewController.m
//  epcoding-ios
//
//  Created by David Mann on 10/14/13.
//  Copyright (c) 2013 David Mann. All rights reserved.
//

#import "EPSDetailViewController.h"
#import "EPSCodes.h"
#import "EPSProcedureKeys.h"
#import "EPSProcedureKey.h"

@interface EPSDetailViewController ()

@property (strong, nonatomic) UIPopoverController *masterPopoverController;

- (void)configureView;

@end

@implementation EPSDetailViewController
{
    NSInteger cellHeight;
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;

        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.title = _detailItem;
        NSDictionary *codeDictionary = [EPSCodes codeDictionary];
        NSDictionary *keyDictionary = [EPSProcedureKeys keyDictionary];
        NSString *primaryCodeKey = [[keyDictionary valueForKey:_detailItem] primaryCodesKey];
        NSString *secondaryCodeKey = [[keyDictionary valueForKey:_detailItem] secondaryCodesKey];
        NSString *disabledCodeKey = [[keyDictionary valueForKey:_detailItem] disabledCodesKey];
        self.disablePrimaryCodes = [[keyDictionary valueForKey:_detailItem] disablePrimaryCodes];
        self.ignoreNoSecondaryCodesSelected = [[keyDictionary valueForKey:_detailItem] ignoreNoSecondaryCodesSelected];
        if ([primaryCodeKey isEqualToString:ALL_EP_CODES_PRIMARY_CODES]) {
            self.primaryCodes = [EPSCodes allCodesSorted];
        }
        else {
            NSArray *primaryKeys = [codeDictionary valueForKey:primaryCodeKey];
            self.primaryCodes = [EPSCodes getCodesForCodeNumbers:primaryKeys];
        }
        if (![secondaryCodeKey isEqualToString:NO_CODE_KEY]) {
            NSArray *secondaryKeys = [codeDictionary valueForKey:secondaryCodeKey];
            self.secondaryCodes = [EPSCodes getCodesForCodeNumbers:secondaryKeys];
        }
        if (![disabledCodeKey isEqualToString:NO_CODE_KEY]) {
            NSArray *disabledKeys = [codeDictionary valueForKey:disabledCodeKey];
            self.disabledCodesSet = [NSSet setWithArray:disabledKeys];
        }
        // must reload data for iPad detail view to refresh, also use default cell height
        // TODO can I get default cell height from somewhere?
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            cellHeight = 44;    // seems to be the default height for iPhone
            [self.codeTableView reloadData];
        }
        else {
            cellHeight = 65;
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn addTarget:self action:@selector(showHelp) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController setToolbarHidden:NO];
    UIBarButtonItem *buttonSummarize = [[ UIBarButtonItem alloc ] initWithTitle: @"Summarize"
                                                                     style: UIBarButtonItemStyleBordered
                                                                    target: self
                                                                    action: nil ];
    UIBarButtonItem *buttonClear = [[UIBarButtonItem alloc]initWithTitle:@"Clear" style:UIBarButtonItemStyleBordered target:self action:@selector(clearEntries)];
    UIBarButtonItem *buttonSave = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:nil];
    self.toolbarItems = [ NSArray arrayWithObjects: buttonSummarize, buttonClear, buttonSave, nil ];
    // e.g. @selector(goNext:)
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    // TODO check to see how resources handled in iOS 7.  Do I need to do this?
}

- (void)showHelp {
    [self performSegueWithIdentifier:@"showHelp" sender:nil];
}

- (void)clearEntries
{
    for (EPSCode *primaryCode in self.primaryCodes) {
        if (!self.disablePrimaryCodes) {
            primaryCode.selected = NO;
        }
    }
    for (EPSCode *secondaryCode in self.secondaryCodes) {
        secondaryCode.selected = NO;
        
    }
    [self.codeTableView reloadData];
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Procedures", @"Procedures");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    switch (section) {
        case 0:
            numberOfRows = [self.primaryCodes count];
            break;
        case 1:
            numberOfRows = [self.secondaryCodes count];
            break;
        default:
            break;
    }
    return numberOfRows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.secondaryCodes == nil) {
        return 1;
    }
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = [[NSString alloc] init];
    switch(section) {
        case 0:
            title = @"Primary Codes";
            break;
        case 1:
            title = @"Other Codes";
            break;
        default:
            title = nil;
            break;
    }
    return title;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *codeCellIdentifier = @"CodeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:codeCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:codeCellIdentifier];
    }
    BOOL isSelected = NO;
    BOOL isDisabled = NO;
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    EPSCode *code;
    if (section == 0) {
        code = [self.primaryCodes objectAtIndex:row];
        isDisabled = self.disablePrimaryCodes;
    }
    else {
        code = [self.secondaryCodes objectAtIndex:row];
        if ([self.disabledCodesSet containsObject:[code number]]) {
            isDisabled = YES;
        }
    }

    cell.textLabel.text = [code unformattedCodeDescription];
    cell.detailTextLabel.text = [code unformattedCodeNumber];
    isSelected = [code selected];
    
   
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    //cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    
    
    if (isDisabled) {
        // primary disabled codes always selected, secondary never selected
        if (section == 0) { // primary code
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [cell setBackgroundColor:[UIColor greenColor]];
        }
        else {  // secondary code
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell setBackgroundColor:[UIColor redColor]];
        }
        [cell setUserInteractionEnabled:NO];
    }
    else {
        cell.accessoryType = (isSelected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone);
        // must specifically set this, or will be set randomly
        [cell setBackgroundColor:nil];
        [cell setUserInteractionEnabled:YES];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSUInteger row = indexPath.row;
    NSUInteger section = indexPath.section;
    if (section == 0) {
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [[self.primaryCodes objectAtIndex:row] setSelected:NO];
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [[self.primaryCodes objectAtIndex:row] setSelected:YES];
        }
    } else {
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [[self.secondaryCodes objectAtIndex:row] setSelected:NO];
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [[self.secondaryCodes objectAtIndex:row] setSelected:YES];
        }
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}


@end
