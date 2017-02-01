//
//  EPSTimeCalculatorViewController.m
//  EP Coding
//
//  Created by David Mann on 1/30/17.
//  Copyright © 2017 David Mann. All rights reserved.
//

#import "EPSTimeCalculatorViewController.h"

@interface EPSTimeCalculatorViewController ()

@end

@implementation EPSTimeCalculatorViewController

{
    NSDateFormatter *dateFormatter;
    NSString *dateString;
    BOOL start;
    NSString *startString;
    NSString *endString;
    BOOL cancel;
    NSDate *startTime;
    NSDate *endTime;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    UIBarButtonItem *calculateButton = [[ UIBarButtonItem alloc ] initWithTitle: @"Calculate" style: UIBarButtonItemStylePlain target: self action: @selector(calculate)];

    self.toolbarItems = [ NSArray arrayWithObjects: cancelButton, calculateButton, nil];

    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    
    startString = @"Start";
    endString = @"End";
    
    start = YES;
    cancel = YES;

    startTime = [self.datePicker date];
    self.time = 0;
    [self showTime];
}

- (void)showTime {
    // a noop now, I think it is too busy when the title shows the selected time.
//    dateString = [dateFormatter stringFromDate:[self.datePicker date]];
//    dateString = [NSString stringWithFormat:start ? @"Start: %@" : @"End: %@", dateString];
//    self.title = dateString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.delegate sendTimeDataBack:cancel sedationTime:self.time];
}

- (void)cancel {
    cancel = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)calculate {
    self.time = round([endTime timeIntervalSinceDate:startTime] / 60.0);
    if (self.time < 1) {
        self.time = 0;
    }
    cancel = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)datePickerChanged:(id)sender {
    if (start) {
        startTime = [self.datePicker date];
    }
    else {
        endTime = [self.datePicker date];
    }
    [self showTime];
}

- (IBAction)timeControlChanged:(id)sender {
    if (self.timeSegmentedControl.selectedSegmentIndex == 0) {
        start = YES;
        startTime = [self.datePicker date];
    }
    else {
        start = NO;
        endTime = [self.datePicker date];
    }
    [self showTime];
}
@end
