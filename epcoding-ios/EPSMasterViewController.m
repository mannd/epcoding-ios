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
    ////    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    self.clearsSelectionOnViewWillAppear = NO;
    // //       self.preferredContentSize = CGSizeMake(320.0, 600.0);
    ////    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showMenu)];
    self.navigationItem.rightBarButtonItem = btn;
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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [self.navigationController setToolbarHidden:YES];
    if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) {
        NSLog(@"show master view");
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) traitCollectionDidChange: (UITraitCollection *) previousTraitCollection {
    [super traitCollectionDidChange: previousTraitCollection];
    if ((self.traitCollection.verticalSizeClass != previousTraitCollection.verticalSizeClass)
        || (self.traitCollection.horizontalSizeClass != previousTraitCollection.horizontalSizeClass)) {
        // your custom implementation here
        NSLog(@"orientation change");
        if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) {
            NSLog(@"horizontal compact");
        }
    }
}

- (void)showMenu {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Search", @"Device Wizard", @"Help", nil];
    [actionSheet showInView:self.view];
    
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

// UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self performSegueWithIdentifier:@"showSearch" sender:self];
            break;
        case 1:
            [self performSegueWithIdentifier:@"showWizard" sender:self];
            break;
        case 2:
            [self performSegueWithIdentifier:@"showHelp" sender:self];
            break;
    }
}

//// UISplitViewController delegate
//#pragma mark - Split view
//
//- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
//    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[EPSDetailViewController class]] && ([(EPSDetailViewController *)[(UINavigationController *)secondaryViewController topViewController] detailItem] == nil)) {
//        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
//        return YES;
//    } else {
//        return NO;
//    }
//}


@end
