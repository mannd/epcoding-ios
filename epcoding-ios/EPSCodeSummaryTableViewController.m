//
//  EPSCodeSummaryTableViewController.m
//  EP Coding
//
//  Created by David Mann on 2/28/14.
//  Copyright (c) 2014 David Mann. All rights reserved.
//

#import "EPSCodeSummaryTableViewController.h"
#import "EPSCode.h"
#import "EPSCodeAnalyzer.h"
#import "EPSCodeError.h"

//#define WARNING_SYMBOL @"\u26A0"
//#define ERROR_SYMBOL @"\u2620"
//#define OK_SYMBOL @"\u263A"


@interface EPSCodeSummaryTableViewController ()
@property (strong, nonatomic) EPSCodeAnalyzer *codeAnalyzer;
@end

@implementation EPSCodeSummaryTableViewController {
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
    [self setTitle:@"Code Summary"];
    cellHeight = 65;
    EPSCodeAnalyzer *analyzer = [[EPSCodeAnalyzer alloc] initWithPrimaryCodes:self.selectedPrimaryCodes secondaryCodes:self.selectedSecondaryCodes ignoreNoSecondaryCodes:self.ignoreNoSecondaryCodesSelected sedationCodes:self.selectedSedationCodes sedationStatus:self.sedationStatus];
    self.codeAnalyzer = analyzer;
    self.codeErrors = [analyzer analysis];
    self.selectedCodes = [analyzer allCodes];
    
    
//    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIColor *)colorForWarningLevel:(enum status)level {
    UIColor *color;
    switch (level) {
        case GOOD:
            color = [UIColor greenColor];
            break;
        case WARNING:
            color = [UIColor orangeColor];
            break;
        case ERROR:
        default:
            color = [UIColor redColor];
            break;
    }
    return color;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return @"Selected Codes";
    return @"Analysis";

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0)
        return [self.selectedCodes count];
    return [self.codeErrors count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    if ([indexPath section] == 0) {
        EPSCode *code = [self.selectedCodes objectAtIndex:[indexPath row]];
        cell.textLabel.text = [code unformattedCodeNumber];
        cell.detailTextLabel.text = [code unformattedCodeDescription];
        cell.backgroundColor = [self colorForWarningLevel:[code codeStatus]];
    }
    else {
        EPSCodeError *error = [self.codeErrors objectAtIndex:[indexPath row]];
        cell.textLabel.text = [error message];
        NSString *errorCodes = [EPSCodeAnalyzer codeNumbersToString:[error codes]];
        cell.detailTextLabel.text = errorCodes;
        cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
        cell.backgroundColor = [self colorForWarningLevel:[error warningLevel]];
    }
    
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;

    // default gray color looks bad when background color is red or orange
    cell.detailTextLabel.textColor = [UIColor blackColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] == 1)
        return 80;
    return cellHeight;
}

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

*/

@end
