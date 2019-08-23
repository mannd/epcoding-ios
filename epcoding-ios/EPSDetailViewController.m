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
#import "EPSModifiers.h"
#import "EPSAbout.h"

#define HIGHLIGHT systemYellowColor
//#define DISABLED_COLOR lightGrayColor
// gray stripes on white background make it easier to read code
#define DISABLED_COLOR whiteColor

@interface EPSDetailViewController ()

@end

@implementation EPSDetailViewController
{
    NSInteger cellHeight;
    BOOL isAllCodesModule;
    UIImage *backgroundImage;
    EPSCode *selectedCode;  // used for code with long press
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
            [EPSCodes clearMultipliers:self.primaryCodes];
            [EPSCodes clearModifiers:self.primaryCodes];
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
        NSMutableArray *sedationCodes = [[NSMutableArray alloc] init];
        self.sedationCodes = sedationCodes;
        // reset all codes to unadorned codes (but will be overriden by saved codes)
        [EPSCodes clearMultipliersAndModifiers:self.primaryCodes];
        [EPSCodes clearMultipliersAndModifiers:self.secondaryCodes];
        [EPSCodes clearMultipliersAndModifiers:self.sedationCodes];
        // no default modifiers in all codes view
        if (!isAllCodesModule) {
            [self loadDefaultModifiers];
        }
        // allCodes can have saved modifiers, just no default
        [self loadSavedModifiers];
        // load default selected codes
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
    self.buttonSedation = [[UIBarButtonItem alloc] initWithTitle:@"Sedation" style:UIBarButtonItemStylePlain target:self action:@selector(calculateSedation)];
    self.buttonSummarize = [[ UIBarButtonItem alloc ] initWithTitle: @"Summarize" style: UIBarButtonItemStylePlain target: self action: @selector(summarizeCoding)];
    self.buttonClear = [[UIBarButtonItem alloc]initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(clearEntries)];
    self.buttonSave = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveCoding)];
    self.toolbarItems = [NSArray arrayWithObjects: self.buttonSedation, self.buttonSummarize, self.buttonClear, self.buttonSave, nil];
    self.sedationTime = 0;
    self.sameMDPerformsSedation = YES;
    self.patientOver5YearsOld = YES;
    self.sedationStatus = Unassigned;
    self.startSedationDate = nil;
    self.endSedationDate = nil;
    
    self.buttonSedation.tintColor = [UIColor systemRedColor];

    backgroundImage = [UIImage imageNamed:@"stripes5.png"];
    
    // add long press handler
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 1.0; //seconds
    longPress.delegate = self;
    [self.codeTableView addGestureRecognizer:longPress];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self.navigationController setToolbarHidden:NO];
    // Sedation action sheet will disable these buttons, so must re-enable them on
    // return from sedation view.
    // sedation used for all modules
    [self.buttonSedation setEnabled:YES];
    [self.buttonSummarize setEnabled:YES];
    [self.buttonClear setEnabled:YES];
    [self.buttonSave setEnabled:!isAllCodesModule];
    [self.navigationController setToolbarHidden:[[self allPrimaryAndSecondaryCodes] count] == 0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)allPrimaryAndSecondaryCodes {
    NSArray *allCodes = [self.primaryCodes arrayByAddingObjectsFromArray:self.secondaryCodes];
    return allCodes;
}

- (void)showMenu {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* searchAction = [UIAlertAction actionWithTitle:@"Search" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {[self performSegueWithIdentifier:@"showSearch" sender:self];}];
    [actionSheet addAction:searchAction];
    UIAlertAction* wizardAction = [UIAlertAction actionWithTitle:@"Device Wizard" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {[self performSegueWithIdentifier:@"showWizard" sender:self];}];
    [actionSheet addAction:wizardAction];
    UIAlertAction *icd10Action = [UIAlertAction actionWithTitle:@"ICD-10 Codes" style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {[self performSegueWithIdentifier:@"showIcd10Codes" sender:self];}];
    [actionSheet addAction:icd10Action];
    UIAlertAction* helpAction = [UIAlertAction actionWithTitle:@"Help" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {[self performSegueWithIdentifier:@"showHelp" sender:self];}];
    [actionSheet addAction:helpAction];
    UIAlertAction* aboutAction = [UIAlertAction actionWithTitle:@"About" style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action) {[EPSAbout show:self];}];
    [actionSheet addAction:aboutAction];
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
    // FIXME: even with no secondary codes selected this dialog offers to save codes.  Why?
    // FIXME: need to save modifiers even if no codes selected
    if (self.primaryCodes == nil) {
        return;
    }
    if (self.secondaryCodes == nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No codes to save" message:@"Only additional codes can be saved. This group has only primary codes." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel
                                                             handler:nil];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Save default codes" message:@"Save selected codes as a default?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction * action) {[self save];}];
        [alert addAction:okAction];
      
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                             handler:nil];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
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

- (void)loadDefaultModifiers
{
    [EPSCodes loadDefaultModifiers:[self allPrimaryAndSecondaryCodes]];
}

- (void)loadSavedModifiers {
    [EPSCodes loadSavedModifiers:[self allPrimaryAndSecondaryCodes]];
}

- (void)resetSavedModifiers {
    [EPSCodes resetSavedModifiers:[self allPrimaryAndSecondaryCodes]];
}

- (BOOL)sedationCodesAssigned {
    return self.sedationCodes != nil && self.sedationCodes.count > 0;
}

- (void)showSedationCodeSummary {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sedation Codes" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *editCodes = [UIAlertAction actionWithTitle:@"Edit" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){[self openSedationView];}];
    UIAlertAction *addCodes = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){[self openSedationView];}];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){[self.buttonSummarize setEnabled:YES]; [self.buttonSave setEnabled:YES]; [self.buttonClear setEnabled:YES];}];
    
    switch (self.sedationStatus) {
        case Unassigned:
            alert.message = @"Sedation coding not yet assigned for this procedure.";
            [alert addAction:addCodes];
            break;
        case None:
            alert.message = @"No sedation was used in this procedure.";
            [alert addAction:editCodes];
            break;
        case LessThan10Mins:
            alert.message = @"Sedation time < 10 mins\nNo sedation codes can be assigned.";
            [alert addAction:editCodes];
            break;
        case OtherMDCalculated:
            alert.message = [NSString stringWithFormat:@"Sedation by other MD, using:\n %@", [EPSSedationCode printSedationCodes:self.sedationCodes separator:@"\n"]];
            [alert addAction:editCodes];
            break;
        case AssignedSameMD:
            alert.message = [NSString stringWithFormat:@"Sedation by same MD, using:\n %@", [EPSSedationCode printSedationCodes:self.sedationCodes separator:@"\n"]];
            [alert addAction:editCodes];
            break;
    }
    [alert addAction:cancel];
    

    // needed for iPad actionsheet
    alert.popoverPresentationController.barButtonItem = self.toolbarItems.firstObject;
    
    // must inactivate other buttons or weird things happen
    [self.buttonSummarize setEnabled:NO];
    [self.buttonSave setEnabled:NO];
    [self.buttonClear setEnabled:NO];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)calculateSedation
{
    // this means we are in a master view, otherwise there are always primaryCodes
    if (self.primaryCodes == nil) {
        return;
    }
    [self showSedationCodeSummary];
    return;

}

- (void)determineSedationCoding {
    [self.sedationCodes removeAllObjects];
    NSArray *array = [EPSSedationCode sedationCoding:self.sedationTime sameMD:self.sameMDPerformsSedation patientOver5:self.patientOver5YearsOld];
    [self.sedationCodes addObjectsFromArray:array];
}

- (void)openSedationView {
    // add sedation info if it exists
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
        EPSCodeSummaryTableViewController *viewController = segue.destinationViewController;
        // get selected codes (need primary, secondary, etc.  but for now
        NSMutableArray *primaryArray = [[NSMutableArray alloc] init];
        for (EPSCode *code in self.primaryCodes) {
            if ([code selected]) {
                // reset code status to GOOD
                code.codeStatus = GOOD;
                [primaryArray addObject:code];
            }
        }
        NSMutableArray *secondaryArray = [[NSMutableArray alloc] init];
        for (EPSCode *code in self.secondaryCodes) {
            if ([code selected]) {
                code.codeStatus = GOOD;
                [secondaryArray addObject:code];
            }
        }
        NSMutableArray *sedationArray = [[NSMutableArray alloc] init];
        for (EPSCode *code in self.sedationCodes) {
            code.codeStatus = GOOD;
            [sedationArray addObject:code];
        }
        [viewController setSelectedPrimaryCodes:primaryArray];
        [viewController setSelectedSecondaryCodes:secondaryArray];
        [viewController setIgnoreNoSecondaryCodesSelected:self.ignoreNoSecondaryCodesSelected];
        [viewController setSelectedSedationCodes:sedationArray];
        viewController.sedationStatus = self.sedationStatus;
    }
    else if ([[segue identifier] isEqualToString:@"showSedation"]) {
        EPSSedationViewController *viewController = segue.destinationViewController;
        viewController.delegate = self;
        viewController.time = self.sedationTime;
        viewController.ageOver5 = self.patientOver5YearsOld;
        viewController.sameMD = self.sameMDPerformsSedation;
        viewController.sedationStatus = self.sedationStatus;
        viewController.startSedationDate = self.startSedationDate;
        viewController.endSedationDate = self.endSedationDate;
    }
    else if ([[segue identifier] isEqualToString:@"showModifiers"]) {
        EPSModifierTableViewController *viewController = segue.destinationViewController;
        viewController.delegate = self;
        viewController.code = selectedCode;
    }
}

- (void)sendSedationDataBack:(BOOL)cancel samePhysician:(BOOL)sameMD lessThan5:(BOOL)lessThan5 sedationTime:(NSInteger)time sedationStatus:(SedationStatus)sedationStatus startDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    if (cancel) {
        return;
    }
    self.sameMDPerformsSedation = sameMD;
    self.patientOver5YearsOld = !lessThan5;
    self.sedationTime = time;
    self.startSedationDate = startDate;
    self.endSedationDate = endDate;
    [self determineSedationCoding];
    self.sedationStatus = sedationStatus;
    self.buttonSedation.tintColor = self.buttonSave.tintColor;
}

-(void)sendModifierDataBack:(BOOL)cancel reset:(BOOL)reset selectedModifiers:(NSArray *)modifiers {
    if (cancel) {
        return;
    }
    if (reset) {
        [EPSCodes clearModifiers:self.primaryCodes];
        [EPSCodes clearModifiers:self.secondaryCodes];
        [EPSCodes clearModifiers:self.sedationCodes];
        [self resetSavedModifiers];
        [self loadDefaultModifiers];
    }
    else {
        [selectedCode clearModifiers];
        [selectedCode addModifiers:modifiers];
    }
    [self.codeTableView reloadData];
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
    if (!cell) {
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
    if (@available(iOS 13.0, *)) {
        cell.detailTextLabel.textColor = [UIColor labelColor];
        cell.textLabel.textColor = [UIColor labelColor];
    } else {
        cell.detailTextLabel.textColor = [UIColor blackColor];
        cell.textLabel.textColor = [UIColor blackColor];
    }

    
    
    if (isDisabled) {
        // primary disabled codes always selected, secondary never selected
        if (section == 0) { // primary code
            code.selected = YES;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [cell setBackgroundColor:[UIColor systemGreenColor]];
            cell.textLabel.textColor = [UIColor systemGrayColor];
            cell.detailTextLabel.textColor = [UIColor systemGrayColor];
        }
        else {  // secondary code
            code.selected = NO;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.backgroundView = [[UIView alloc] init];
            cell.backgroundView.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
            if (@available(iOS 13.0, *)) {
                [cell setBackgroundColor:[UIColor systemBackgroundColor]];
            } else {
                [cell setBackgroundColor:[UIColor DISABLED_COLOR]];
            }
            cell.textLabel.textColor = [UIColor systemGrayColor];
            cell.detailTextLabel.textColor = [UIColor systemGrayColor];
        }
        [cell setUserInteractionEnabled:NO];
    }
    else {
        cell.accessoryType = ([code selected] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone);
        if (@available(iOS 13.0, *)) {
            if ([code selected]) {
                cell.backgroundColor = [UIColor HIGHLIGHT];
                cell.textLabel.textColor = [UIColor blackColor];
                cell.detailTextLabel.textColor = [UIColor blackColor];
            }
            else {
                cell.backgroundColor = [UIColor systemBackgroundColor];
            }

        } else {
            if ([code selected]) {
                cell.backgroundColor = [UIColor HIGHLIGHT];
            }
            else {
                cell.backgroundColor = [UIColor whiteColor];
            }
        }
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
            if (@available(iOS 13.0, *)) {
                cell.backgroundColor = [UIColor systemBackgroundColor];
                cell.textLabel.textColor = [UIColor labelColor];
                cell.detailTextLabel.textColor = [UIColor labelColor];
            } else {
                cell.backgroundColor = [UIColor whiteColor];
            }
            [[self.primaryCodes objectAtIndex:row] setSelected:NO];
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.backgroundColor = [UIColor HIGHLIGHT];
            cell.textLabel.textColor = [UIColor blackColor];
            cell.detailTextLabel.textColor = [UIColor blackColor];
            [[self.primaryCodes objectAtIndex:row] setSelected:YES];
        }
    } else {
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            if (@available(iOS 13.0, *)) {
                cell.backgroundColor = [UIColor systemBackgroundColor];
                cell.textLabel.textColor = [UIColor labelColor];
                cell.detailTextLabel.textColor = [UIColor labelColor];
            } else {
                cell.backgroundColor = [UIColor whiteColor];
            }

            [[self.secondaryCodes objectAtIndex:row] setSelected:NO];
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.backgroundColor = [UIColor HIGHLIGHT];
            cell.textLabel.textColor = [UIColor blackColor];
            cell.detailTextLabel.textColor = [UIColor blackColor];

            [[self.secondaryCodes objectAtIndex:row] setSelected:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma mark - UIGestureRecognizer delegate

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self.codeTableView];
    
    NSIndexPath *indexPath = [self.codeTableView indexPathForRowAtPoint:p];
    if (indexPath == nil) {
        selectedCode = nil;
    } else if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSUInteger section = indexPath.section;
        NSUInteger row = indexPath.row;
        if (section == 0) {
            selectedCode = [self.primaryCodes objectAtIndex:row];
        }
        else {
            selectedCode = [self.secondaryCodes objectAtIndex:row];
        }
        if ([self.disabledCodesSet containsObject:[selectedCode number]]) {
            return;
        }
        [self performSegueWithIdentifier:@"showModifiers" sender:nil];

    } else {
    }
}



@end
