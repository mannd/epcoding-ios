//
//  EPSDateTimeCalculatorTableViewController.m
//  epcoding-ios
//
//  Created by David Mann on 10/31/17.
//  Copyright © 2017 David Mann. All rights reserved.
//

#import "EPSDateTimeCalculatorTableViewController.h"

@interface EPSDateTimeCalculatorTableViewController ()
@property (strong, atomic) NSDateFormatter *formatter;

@end

@implementation EPSDateTimeCalculatorTableViewController

{
    BOOL cancel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    UIBarButtonItem *calculateButton = [[ UIBarButtonItem alloc ] initWithTitle: @"Calculate" style: UIBarButtonItemStylePlain target: self action: @selector(calculate)];
    
    self.toolbarItems = [ NSArray arrayWithObjects: cancelButton, calculateButton, nil];

    self.formatter = [[NSDateFormatter alloc] init];
    [self.formatter setDateStyle:NSDateFormatterMediumStyle];
    [self.formatter setTimeStyle:NSDateFormatterShortStyle];
    
    self.time = 0;
    cancel = YES;

}

- (void)viewWillAppear:(BOOL)animated {
    self.startDatePickerVisible = NO;
    self.startDatePicker.hidden = YES;
    self.startDatePicker.translatesAutoresizingMaskIntoConstraints = NO;
    self.endDatePickerVisible = NO;
    self.endDatePicker.hidden = YES;
    self.endDatePicker.translatesAutoresizingMaskIntoConstraints = NO;
    if (self.startSedationDate == nil) {
        self.startSedationDate = [[NSDate alloc] init];
    }
    if (self.endSedationDate == nil) {
        self.endSedationDate = [[NSDate alloc] init];
    }
    self.startDatePicker.date = self.startSedationDate;
    self.endDatePicker.date = self.endSedationDate;
    self.startCell.detailTextLabel.text = [self.formatter stringFromDate:self.startDatePicker.date];
    self.endCell.detailTextLabel.text = [self.formatter stringFromDate:self.endDatePicker.date];

    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.delegate sendTimeDataBack:cancel sedationTime:self.time
     startDate:self.startSedationDate endDate:self.endSedationDate];
    [super viewWillDisappear:animated];
}

- (void)cancel {
    cancel = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)calculate {
    self.endSedationDate = self.endDatePicker.date;
    self.startSedationDate = self.startDatePicker.date;
    self.time = round([self.endSedationDate timeIntervalSinceDate:self.startSedationDate] / 60.0);
    if (self.time < 1) {
        self.time = 0;
    }
    cancel = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showStartDatePickerCell {
    self.startCell.detailTextLabel.textColor = [UIColor redColor];
    self.startDatePickerVisible = YES;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    self.startDatePicker.alpha = 0.0f;
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.startDatePicker.alpha = 1.0f;
                     } completion:^(BOOL finished){
                         self.startDatePicker.hidden = NO;
                     }];
}

- (void)hideStartDatePickerCell {
    self.startCell.detailTextLabel.textColor = [UIColor darkTextColor];
    self.startDatePickerVisible = NO;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.startDatePicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.startDatePicker.hidden = YES;
                     }];
}

- (void)showEndDatePickerCell {
    self.endCell.detailTextLabel.textColor = [UIColor redColor];
    self.endDatePickerVisible = YES;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    self.endDatePicker.alpha = 0.0f;
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.endDatePicker.alpha = 1.0f;
                     } completion:^(BOOL finished){
                         self.endDatePicker.hidden = NO;
                     }];
}

- (void)hideEndDatePickerCell {
    self.endCell.detailTextLabel.textColor = [UIColor darkTextColor];
    self.endDatePickerVisible = NO;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    [UIView animateWithDuration:0.25
                     animations:^{
                         self.endDatePicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.endDatePicker.hidden = YES;
                     }];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = self.tableView.rowHeight;
    if (indexPath.row == 1) {
        height = self.startDatePickerVisible ? 216.0f : 0.0f;
    }
    if (indexPath.row == 3) {
        height = self.endDatePickerVisible ? 216.0f : 0.0f;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (self.startDatePickerVisible) {
            [self hideStartDatePickerCell];
        }
        else {
            [self showStartDatePickerCell];
            [self hideEndDatePickerCell];
        }
    }
    if (indexPath.row == 2) {
        if (self.endDatePickerVisible) {
            [self hideEndDatePickerCell];
        }
        else {
            [self showEndDatePickerCell];
            [self hideStartDatePickerCell];
        }
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)startDateChanged:(id)sender {
    self.startCell.detailTextLabel.text = [self.formatter stringFromDate:self.startDatePicker.date];
}

- (IBAction)endDateChanged:(id)sender {
    self.endCell.detailTextLabel.text = [self.formatter stringFromDate:self.endDatePicker.date];
}
@end
