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
#import "EPSCodeSummaryTableViewController.h"

#define HIGHLIGHT yellowColor

@interface EPSDetailViewController ()

- (void)configureView;

@end

@implementation EPSDetailViewController
{
    NSInteger cellHeight;
    BOOL isAllCodesModule;
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;

        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        isAllCodesModule = NO;
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
            self.secondaryCodes = nil;
            isAllCodesModule = YES;
        }
        else {
            NSArray *primaryKeys = [codeDictionary valueForKey:primaryCodeKey];
            self.primaryCodes = [EPSCodes getCodesForCodeNumbers:primaryKeys];
        }
        if (![secondaryCodeKey isEqualToString:NO_CODE_KEY]) {
            NSArray *secondaryKeys = [codeDictionary valueForKey:secondaryCodeKey];
            self.secondaryCodes = [EPSCodes getCodesForCodeNumbers:secondaryKeys];
            [self load];
        }
        if (![disabledCodeKey isEqualToString:NO_CODE_KEY]) {
            NSArray *disabledKeys = [codeDictionary valueForKey:disabledCodeKey];
            self.disabledCodesSet = [NSSet setWithArray:disabledKeys];
        }
        [self clearEntries];
        // load defaults
        [self load];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    cellHeight = 65;
    [self configureView];
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showMenu)];
    self.navigationItem.rightBarButtonItem = btn;
    //[self.navigationController setToolbarHidden:NO];
    UIBarButtonItem *buttonSedation = [[UIBarButtonItem alloc] initWithTitle:@"Sedation" style:UIBarButtonItemStylePlain target:self action:@selector(calculateSedation)];
    UIBarButtonItem *buttonSummarize = [[ UIBarButtonItem alloc ] initWithTitle: @"Summarize" style: UIBarButtonItemStylePlain target: self action: @selector(summarizeCoding)];
    UIBarButtonItem *buttonClear = [[UIBarButtonItem alloc]initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(clearEntries)];
    UIBarButtonItem *buttonSave = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveCoding)];
    self.toolbarItems = [ NSArray arrayWithObjects: buttonSedation, buttonSummarize, buttonClear, buttonSave, nil ];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self.navigationController setToolbarHidden:NO];
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showMenu {
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* searchAction = [UIAlertAction actionWithTitle:@"Search" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {[self performSegueWithIdentifier:@"showSearch" sender:self];}];
        [actionSheet addAction:searchAction];
        UIAlertAction* wizardAction = [UIAlertAction actionWithTitle:@"Device Wizard" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {[self performSegueWithIdentifier:@"showWizard" sender:self];}];
        [actionSheet addAction:wizardAction];
        UIAlertAction* helpAction = [UIAlertAction actionWithTitle:@"Help" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {[self performSegueWithIdentifier:@"showHelp" sender:self];}];
        [actionSheet addAction:helpAction];
    
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                             handler:nil];
        [actionSheet addAction:cancelAction];
    
        actionSheet.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;

        [self presentViewController:actionSheet animated:YES completion:nil];
}


- (void)showHelp
{
    [self performSegueWithIdentifier:@"showHelp" sender:nil];
}

- (void)clearEntries
{
    [self clearSelected];
    [self.codeTableView reloadData];
}

- (void)saveCoding
{
    if (self.primaryCodes == nil) {
        return;
    }
    if (self.secondaryCodes == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No codes to save" message:@"Only additional codes can be saved. This group has only primary codes." delegate:self
            cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Save default codes" message:@"Save selected codes as a default?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alert show];
    }
        
}


- (void)save
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *selectedCodes = [[NSMutableArray alloc] init];
    for (EPSCode *code in self.secondaryCodes) {
        if ([code selected]) {
            [selectedCodes addObject:[code number]];
        }
    }
    [defaults setValue:selectedCodes forKey:_detailItem];
}

- (void)load
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = [defaults arrayForKey:_detailItem];
    if (array != nil) {
        NSSet *set = [[NSSet alloc] initWithArray:array];
        for (EPSCode *code in self.secondaryCodes) {
            if ([set containsObject:[code number]]) {
                [code setSelected:YES];
            }
        }
    }
}

- (void)calculateSedation
{
    [self performSegueWithIdentifier:@"showSedation" sender:nil];
}

- (void)summarizeCoding
{
    if (self.primaryCodes == nil) {
        return;
    }
    [self performSegueWithIdentifier:@"showSummary" sender:nil];
}

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showSummary"]) {
        // get selected codes (need primary, secondary, etc.  but for now
        NSMutableArray *primaryArray = [[NSMutableArray alloc] init];
        for (EPSCode *code in self.primaryCodes) {
            if ([code selected]) {
                // reset code status to GOOD
                code.codeStatus = GOOD;
                [primaryArray addObject:code];
            }
        }
        [[segue destinationViewController] setSelectedPrimaryCodes:primaryArray];
        NSMutableArray *secondaryArray = [[NSMutableArray alloc] init];
        for (EPSCode *code in self.secondaryCodes) {
            if ([code selected]) {
                code.codeStatus = GOOD;
                [secondaryArray addObject:code];
            }
        }
        [[segue destinationViewController] setSelectedSecondaryCodes:secondaryArray];
        [[segue destinationViewController] setIgnoreNoSecondaryCodesSelected:self.ignoreNoSecondaryCodesSelected];
    }
}


- (void)clearSelected
{
    if (self.primaryCodes == nil) {
        return;
    }
    for (EPSCode *primaryCode in self.primaryCodes) {
        if (!self.disablePrimaryCodes) {
            primaryCode.selected = NO;
        }
    }
    for (EPSCode *secondaryCode in self.secondaryCodes) {
        secondaryCode.selected = NO;
    }
}

#pragma mark - Alert view

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self save];
    }
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
    // this ensures no title for blank table (iPad startup)
    if (self.primaryCodes == nil) {
        return 0;
    }
    if (self.secondaryCodes == nil) {
        return 1;
    }
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title;
    switch(section) {
        case 0:
            title = (isAllCodesModule ? @"Codes Sorted By Number" : @"Primary Codes");
            break;
        case 1:
            title = @"Additional Codes";
            break;
        default:
            title = @"";
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
    if (isAllCodesModule) {
        cell.detailTextLabel.text = [code unformattedCodeDescription];
        cell.textLabel.text = [code unformattedCodeNumber];
    }
    else {
        cell.textLabel.text = [code unformattedCodeDescription];
        cell.detailTextLabel.text = [code unformattedCodeNumber];
    }
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    //cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    // default gray color looks bad when background color is red or orange
    cell.detailTextLabel.textColor = [UIColor blackColor];

    
    
    if (isDisabled) {
        // primary disabled codes always selected, secondary never selected
        if (section == 0) { // primary code
            code.selected = YES;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [cell setBackgroundColor:[UIColor greenColor]];
        }
        else {  // secondary code
            code.selected = NO;
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell setBackgroundColor:[UIColor redColor]];
        }
        [cell setUserInteractionEnabled:NO];
    }
    else {
        cell.accessoryType = ([code selected] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone);
        // must specifically set this, or will be set randomly
        cell.backgroundColor = ([code selected] ? [UIColor HIGHLIGHT] : [UIColor whiteColor]);
        //[cell setBackgroundColor:[UIColor whiteColor]];
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
            cell.backgroundColor = [UIColor whiteColor];
            [[self.primaryCodes objectAtIndex:row] setSelected:NO];
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.backgroundColor = [UIColor HIGHLIGHT];
            [[self.primaryCodes objectAtIndex:row] setSelected:YES];
        }
    } else {
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.backgroundColor = [UIColor whiteColor];

            [[self.secondaryCodes objectAtIndex:row] setSelected:NO];
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.backgroundColor = [UIColor HIGHLIGHT];

            [[self.secondaryCodes objectAtIndex:row] setSelected:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}



@end
