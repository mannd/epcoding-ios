//
//  EPSMasterViewController.m
//  epcoding-ios
//
//  Created by David Mann on 10/14/13.
//  Copyright (c) 2013 David Mann. All rights reserved.
//

#import "EPSMasterViewController.h"

#import "EPSDetailViewController.h"
#import "EPSProcedureKeys.h"
#import "EPSAbout.h"

// Extension to allow toggle the master view in portrait mode
// See http://stackoverflow.com/questions/27243158/hiding-the-master-view-controller-with-uisplitviewcontroller-in-ios8
@interface UISplitViewController (ExtendedSplitViewController)
@end

@implementation UISplitViewController (ExtendedSplitViewController)
- (void)toggleMasterView {
    UIBarButtonItem *barButtonItem = self.displayModeButtonItem;
    [[UIApplication sharedApplication] sendAction:barButtonItem.action to:barButtonItem.target from:nil forEvent:nil];
}
@end

@interface EPSMasterViewController () {
    
}
@end

@implementation EPSMasterViewController

- (void)awakeFromNib
{
    self.clearsSelectionOnViewWillAppear = NO;
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setTitle:@"Procedures"];
    
    NSArray *array = [[NSArray alloc] initWithObjects:
                      AFB_ABLATION_TITLE,
                      SVT_ABLATION_TITLE,
                      VT_ABLATION_TITLE,
                      AVN_ABLATION_TITLE,
                      EP_TESTING_TITLE,
                      NEW_PPM_TITLE,
                      NEW_ICD_TITLE,
                      REPLACE_PPM_TITLE,
                      REPLACE_ICD_TITLE,
                      UPGRADE_SYSTEM_TITLE,
                      SUBQ_ICD_TITLE,
                      OTHER_PROCEDURE_TITLE,
                      ALL_EP_CODES_TITLE, nil];
    self.procedureTypes = array;
    // put right button only on iPhone, it will appear twice in the view on iPad
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed: @"more"] style:UIBarButtonItemStylePlain target:self action:@selector(showMenu)];
        self.navigationItem.rightBarButtonItem = btn;
    }
    // Default preferredDisplayMode: overlays in portrait mode and is on left border in landscape mode.
    self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAutomatic;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [self.navigationController setToolbarHidden:YES];
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


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _procedureTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSString *label = _procedureTypes[indexPath.row];
    cell.textLabel.text = label;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *procedure = _procedureTypes[indexPath.row];
        EPSDetailViewController *controller = (EPSDetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:procedure];
        [self.splitViewController toggleMasterView];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}




@end
