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
#import "EPSSedationViewController.h"
#import "EPSModifierTableViewController.h"
#import "EPSModifiers.h"

#define HIGHLIGHT yellowColor
#define DISABLED_COLOR lightGrayColor
//#define DISABLED_COLOR whiteColor

@interface EPSDetailViewController ()

- (void)configureView;

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
        /* TODO: 
         Modifiers are code module specific and come in 3 layers:
         1. Programmatic defaults - recommended modifiers that really shouldn't need to be changed, exception being allcode modules
         where there are no programmatic defaults but just pure codes (but they can be changed by other layers to follow.
         2. Saved modifiers - if someone doesn't want to use a modifier, it can be deleted and saved, or new modifiers can be added.  These will be per code module and will override layer 1.
         3. Added modifiers.  These are added per appearance of the module and don't last between uses.  They are specific to a specific case.
         */
       
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
    self.toolbarItems = [ NSArray arrayWithObjects: self.buttonSedation, self.buttonSummarize, self.buttonClear, self.buttonSave, nil ];
    self.sedationTime = 0;
    self.sameMDPerformsSedation = YES;
    self.patientOver5YearsOld = YES;
    self.noSedationAdministered = NO;
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
    [self.buttonSedation setEnabled:!isAllCodesModule];
    [self.buttonSummarize setEnabled:YES];
    [self.buttonClear setEnabled:YES];
    [self.buttonSave setEnabled:!isAllCodesModule];
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
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Save default codes" message:@"Save selected codes and modifiers as a default?" preferredStyle:UIAlertControllerStyleAlert];
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
    // TODO: do any primary codes need default modifiers?
    for (EPSCode *code in self.secondaryCodes) {
        NSArray *modifiers = [[EPSCodes defaultModifiers] valueForKey:code.number];
        if (modifiers != nil) {
            [code addModifiers:modifiers];
        }
    }
}

- (void)loadSavedModifiers {
    // TODO: expand to primary codes, sedation codes too?
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    for (EPSCode *code in [self allPrimaryAndSecondaryCodes]) {
        NSArray *modifierNumbers = [defaults arrayForKey:code.number];
        if (modifierNumbers != nil) {
            // override default modifiers, just use saved modifiers, including no modifiers
            [code clearModifiers];
            for (NSString *modifierNumber in modifierNumbers) {
                EPSModifier *modifier = [EPSModifiers getModifierForNumber:modifierNumber];
                [code addModifier:modifier];
            }
        }
    }
}

- (void)resetSavedModifiers {
    //TODO: expand to primary codes, etc.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    for (EPSCode *code in [self allPrimaryAndSecondaryCodes]) {
        [defaults removeObjectForKey:code.number];
    }
}

- (BOOL)sedationCodesAssigned {
    return self.sedationCodes != nil && self.sedationCodes.count > 0;
}

- (void)showSedationCodeSummary:(BOOL)noCodesExist {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sedation Codes" message:@"No sedation codes assigned." preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *editCodes = [UIAlertAction actionWithTitle:@"Edit" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){[self openSedationView];}];
    UIAlertAction *addCodes = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){[self openSedationView];}];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){[self.buttonSummarize setEnabled:YES]; [self.buttonSave setEnabled:YES]; [self.buttonClear setEnabled:YES];}];
    if (self.noSedationAdministered) {
        alert.message = @"No sedation administered for this procedure.";
        [alert addAction:editCodes];
    }
    else if (noCodesExist) {
        if (self.sedationTime < 10 && self.sedationTime > 0) {
            alert.message = @"Sedation time < 10 mins\nNo sedation codes assigned.";
            [alert addAction:editCodes];
        }
        else {
            [alert addAction:addCodes];
        }
    }
    else {
        [alert addAction:editCodes];
        NSString *firstCode = [[self.sedationCodes objectAtIndex:0] unformattedCodeNumber];
        NSString *secondCode = @"";
        if ([self.sedationCodes count] == 2) {
            secondCode = [[self.sedationCodes objectAtIndex:1] unformattedCodeNumber];
        }
        alert.message = [NSString stringWithFormat:@"%@\n%@", firstCode, secondCode];
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
    [self showSedationCodeSummary:![self sedationCodesAssigned]];
    return;

}

- (void)determineSedationCoding {
    [self.sedationCodes removeAllObjects];
    if (self.sedationTime >= 10) {
        if (self.sameMDPerformsSedation) {
            if (self.patientOver5YearsOld) {
                [self.sedationCodes addObject:[EPSCodes getCodeForNumber:@"99152"]];
            }
            else {
                [self.sedationCodes addObject:[EPSCodes getCodeForNumber:@"99151"]];
            }
        }
        else {
            if (self.patientOver5YearsOld) {
                [self.sedationCodes addObject:[EPSCodes getCodeForNumber:@"99156"]];
            }
            else {
                [self.sedationCodes addObject:[EPSCodes getCodeForNumber:@"99151"]];
            }
        }
    }
    if (self.sedationTime >= 23) {
        NSInteger multiplier = [EPSCodes codeMultiplier:self.sedationTime];
        EPSCode *code = [[EPSCode alloc] init];
        if (self.sameMDPerformsSedation) {
            code = [EPSCodes getCodeForNumber:@"99153"];
        }
        else {
            code = [EPSCodes getCodeForNumber:@"99157"];
        }
        code.multiplier = multiplier;
        [self.sedationCodes addObject:code];
    }
    
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
    }
    else if ([[segue identifier] isEqualToString:@"showSedation"]) {
        EPSSedationViewController *viewController = segue.destinationViewController;
        viewController.delegate = self;
        viewController.time = self.sedationTime;
        viewController.ageOver5 = self.patientOver5YearsOld;
        viewController.sameMD = self.sameMDPerformsSedation;
    }
    else if ([[segue identifier] isEqualToString:@"showModifiers"]) {
        EPSModifierTableViewController *viewController = segue.destinationViewController;
        viewController.delegate = self;
        viewController.code = selectedCode;
    }
}

- (void)sendSedationDataBack:(BOOL)cancel samePhysician:(BOOL)sameMD lessThan5:(BOOL)lessThan5 sedationTime:(NSInteger)time noSedation:(BOOL)noSedation
{
    if (cancel) {
        return;
    }
    self.sameMDPerformsSedation = sameMD;
    self.patientOver5YearsOld = !lessThan5;
    self.sedationTime = time;
    [self determineSedationCoding];
    self.noSedationAdministered = noSedation;
//    if (self.noSedationAdministered || self.sedationTime > 0 || !self.sameMDPerformsSedation) {
//        self.buttonSedation.title = @"Edit Sedation";
//    }
 //   [self showSedationCodeSummary:![self sedationCodesAssigned]];
}

-(void)sendModifierDataBack:(BOOL)cancel reset:(BOOL)reset selectedModifiers:(NSArray *)modifiers {
    if (cancel) {
        return;
    }
    if (reset) {
        NSLog(@"Reset modifiers");
        // TODO: are we resetting just modified code, or all codes in module?
// this:        [selectedCode clearModifiers];
        // or this:
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
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:codeCellIdentifier];
    
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
            
            // TODO: prohibited cell with striped background
            cell.backgroundView = [[UIView alloc] init];
            cell.backgroundView.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
            [cell setBackgroundColor:[UIColor DISABLED_COLOR]];
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

#pragma mark - UIGestureRecognizer delegate

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self.codeTableView];
    
    NSIndexPath *indexPath = [self.codeTableView indexPathForRowAtPoint:p];
    if (indexPath == nil) {
        selectedCode = nil;
        NSLog(@"long press on table view but not on a row");
    } else if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"long press on table view at row %ld", indexPath.row);
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
        NSLog(@"gestureRecognizer.state = %ld", gestureRecognizer.state);
    }
}



@end
