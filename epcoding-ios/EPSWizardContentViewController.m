//
//  EPSWizardContentViewController.m
//  EP Coding
//
//  Created by David Mann on 4/18/14.
//  Copyright (c) 2014 David Mann. All rights reserved.
//

#import "EPSWizardContentViewController.h"
#import "EPSCodes.h"
#import "EPSModifierTableViewController.h"
#import "EPSSedationCode.h"
#import "EPSSedationViewController.h"

@interface EPSWizardContentViewController ()

@end

@implementation EPSWizardContentViewController
{
    NSInteger cellHeight;
    EPSCode *selectedCode;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.contentLabel.text = self.contentText;
    self.contentLabel.numberOfLines = 0;
    [self.contentLabel sizeToFit];
    cellHeight = 65;
    [self.contentLabel setFont:[UIFont systemFontOfSize:14.0f]];
    
    // add long press handler
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 1.0; //seconds
    longPress.delegate = self;
    [self.codeTableView addGestureRecognizer:longPress];
    
    self.sedationTime = 0;
    self.sameMDPerformsSedation = YES;
    self.patientOver5YearsOld = YES;
    self.sedationStatus = Unassigned;
    self.sedationCodes = [[NSMutableArray alloc] init];
    self.startSedationDate = nil;
    self.endSedationDate = nil;
     
    // Add default codes here
    [self clearAllMultipliersAndModifiers];
    [self loadDefaultModifiers];
    [self loadSavedModifiers];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendSedationDataBack:(BOOL)cancel samePhysician:(BOOL)sameMD lessThan5:(BOOL)lessThan5 sedationTime:(NSInteger)time sedationStatus:(SedationStatus)sedationStatus startDate:(NSDate *)startDate endDate:(NSDate *)endDate{
    if (cancel) {
        return;
    }
    EPSSedationCode *sedationCode = (EPSSedationCode *)selectedCode;
    self.sameMDPerformsSedation = sameMD;
    self.patientOver5YearsOld = !lessThan5;
    self.sedationTime = time;
    self.startSedationDate = startDate;
    self.endSedationDate = endDate;
    [self.sedationCodes removeAllObjects];
    NSArray *array = [EPSSedationCode sedationCoding:time sameMD:sameMD patientOver5:!lessThan5];
    [self.sedationCodes addObjectsFromArray:array];
    sedationCode.sedationCodes = self.sedationCodes;
    sedationCode.sedationStatus = self.sedationStatus = sedationStatus;
    [self.codeTableView reloadData];
}

- (void)sendModifierDataBack:(BOOL)cancel reset:(BOOL)reset selectedModifiers:(NSArray *)modifiers {
    if (cancel) {
        return;
    }
    if (reset) {
        [self clearAllModifiers];
        [self resetSavedModifiers];
        [self loadDefaultModifiers];
    }
    else {
        [selectedCode clearModifiers];
        [selectedCode addModifiers:modifiers];
    }
    [self.codeTableView reloadData];
}

- (void)clearAllMultipliersAndModifiers {
    for (NSArray *array in self.allCodes) {
        [EPSCodes clearMultipliersAndModifiers:array];
    }
}

- (void)clearAllModifiers {
    for (NSArray *array in self.allCodes) {
        [EPSCodes clearModifiers:array];
    }
}

- (void)loadDefaultModifiers {
    for (NSArray *array in self.allCodes) {
        [EPSCodes loadDefaultModifiers:array];
    }
}

- (void)loadSavedModifiers {
    for (NSArray *array in self.allCodes) {
        [EPSCodes loadSavedModifiers:array];
    }
}

- (void)resetSavedModifiers {
    for (NSArray *array in self.allCodes) {
        [EPSCodes resetSavedModifiers:array];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"showModifiersFromWizard"]) {
        EPSModifierTableViewController *viewController = segue.destinationViewController;
        viewController.delegate = self;
        viewController.code = selectedCode;
    }
    if ([[segue identifier] isEqualToString:@"showSedationFromWizard"]) {
        EPSSedationViewController *viewController = segue.destinationViewController;
        viewController.delegate = self;
        viewController.time = self.sedationTime;
        viewController.ageOver5 = self.patientOver5YearsOld;
        viewController.sameMD = self.sameMDPerformsSedation;
        viewController.startSedationDate = self.startSedationDate;
        viewController.endSedationDate = self.endSedationDate;
        viewController.sedationStatus = self.sedationStatus;
    }

}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.codes count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *wizardCellIdentifier = @"wizardCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:wizardCellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:wizardCellIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    EPSCode *code = nil;
    

    code = [self.codes objectAtIndex:row];

    cell.detailTextLabel.text = [code unformattedCodeDescription];
    cell.textLabel.text = [code unformattedCodeNumber];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    if (@available(iOS 13.0, *)) {
        cell.detailTextLabel.textColor = [UIColor labelColor];
    } else {
        // Fallback on earlier versions
    }
    cell.accessoryType = ([code selected] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone);
    // must specifically set this, or will be set randomly
    if ([code selected]) {
        cell.backgroundColor = [UIColor yellowColor];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    else {
        if (@available(iOS 13.0, *)) {
            cell.backgroundColor = [UIColor systemBackgroundColor];
            cell.textLabel.textColor = [UIColor labelColor];
            cell.detailTextLabel.textColor = [UIColor labelColor];
        } else {
            cell.backgroundColor = [UIColor whiteColor];
        }
    }
    [cell setUserInteractionEnabled:YES];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSUInteger row = indexPath.row;
    selectedCode = [self.codes objectAtIndex:row];
    if (selectedCode.number == SEDATION_CODE_NUMBER) {
        [self performSegueWithIdentifier:@"showSedationFromWizard" sender:nil];
        // selected sedation codes stays selected
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.backgroundColor = [UIColor yellowColor];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.textColor = [UIColor blackColor];
        [[self.codes objectAtIndex:row] setSelected:YES];
    }
    else if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        if (@available(iOS 13.0, *)) {
            cell.backgroundColor = [UIColor systemBackgroundColor];
            cell.textLabel.textColor = [UIColor labelColor];
            cell.detailTextLabel.textColor = [UIColor labelColor];
        } else {
            cell.backgroundColor = [UIColor whiteColor];
        }
        [[self.codes objectAtIndex:row] setSelected:NO];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.backgroundColor = [UIColor yellowColor];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.textColor = [UIColor blackColor];
        [[self.codes objectAtIndex:row] setSelected:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - Gesture recognizer delegate

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self.codeTableView];
    
    NSIndexPath *indexPath = [self.codeTableView indexPathForRowAtPoint:p];
    if (indexPath == nil) {
        selectedCode = nil;
    } else if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSUInteger row = indexPath.row;
        selectedCode = [self.codes objectAtIndex:row];
        // ignore long press for special sedation code - it has no modifiers
        if (selectedCode.number == SEDATION_CODE_NUMBER) {
            return;
        }
        [self performSegueWithIdentifier:@"showModifiersFromWizard" sender:nil];
        
    } else {
    }
}

@end
