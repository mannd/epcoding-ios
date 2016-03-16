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

@interface EPSMasterViewController () {

}
@end

@implementation EPSMasterViewController

//- (void)awakeFromNib
//{
////    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//        self.clearsSelectionOnViewWillAppear = NO;
// //       self.preferredContentSize = CGSizeMake(320.0, 600.0);
////    }
//    [super awakeFromNib];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

        UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showMenu)];
        self.navigationItem.rightBarButtonItem = btn;
        [self setTitle:@"EP Coding"];
//    }
//    else
//        [self setTitle:@"Procedures"];
//    
    self.detailViewController = (EPSDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    


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
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//        NSString *procedure = _procedureTypes[indexPath.row];
//        self.detailViewController.detailItem = procedure;
////    }
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *procedure = _procedureTypes[indexPath.row];
        EPSDetailViewController *controller = (EPSDetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:procedure];
//        self.detailViewController.detailItem = procedure;
//        [[segue destinationViewController] setDetailItem:procedure];
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

@end
