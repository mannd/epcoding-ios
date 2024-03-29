//
//  EPSSedationViewController.m
//  EP Coding
//
//  Created by David Mann on 1/28/17.
//  Copyright © 2017 David Mann. All rights reserved.
//

#import "EPSSedationViewController.h"
#import "EPSDateTimeCalculatorTableViewController.h"
#import "EPSCodes.h"
#import "EPSSedationCode.h"
#import "EPSUtilities.h"

@interface EPSSedationViewController ()

@end

@implementation EPSSedationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.canceled = YES;
    self.timeTextField.delegate = self;
    [self.sameMDSwitch setOn:self.sameMD];
    [self.patientAgeSwitch setOn:self.ageOver5];
    self.timeTextField.text = [NSString stringWithFormat:@"%lu", (long)self.time];
    self.noSedation = NO;
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
    UIBarButtonItem *noSedationButton = [[UIBarButtonItem alloc] initWithTitle:@"No Sedation" style:UIBarButtonItemStylePlain target:self action:@selector(noSedationAction:)];
    UIBarButtonItem *addCodesButton = [[ UIBarButtonItem alloc ] initWithTitle: @"Add Codes" style: UIBarButtonItemStyleDone target: self action: @selector(addCodesAction:)];
    self.toolbarItems = [EPSUtilities spaceoutToolbar:[NSArray arrayWithObjects: cancelButton, noSedationButton, addCodesButton, nil]];
    [self.navigationController setToolbarHidden:NO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"showDateTimeCalculator"]) {
        EPSDateTimeCalculatorTableViewController *viewController = segue.destinationViewController;
        viewController.delegate = self;
        viewController.startSedationDate = self.startSedationDate;
        viewController.endSedationDate = self.endSedationDate;
    }
}

-(void)sendTimeDataBack:(BOOL)canceled sedationTime:(NSInteger)time startDate:(NSDate *)startDate endDate:(NSDate *)endDate;
{
    if (canceled) {
        return;
    }
    self.startSedationDate = startDate;
    self.endSedationDate = endDate;
    self.time = time;
    self.timeTextField.text = [NSString stringWithFormat:@"%lu", (long)time];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.delegate sendSedationDataBack:self.canceled samePhysician:self.sameMD lessThan5:!self.ageOver5 sedationTime:self.time sedationStatus:self.sedationStatus startDate:self.startSedationDate endDate:self.endSedationDate];
    [super viewWillDisappear:animated];
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.timeTextField resignFirstResponder];
}

- (IBAction)cancelAction:(id)sender {
    self.canceled = YES;
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)noSedationAction:(id)sender {
    self.time = 0;
    self.canceled = NO;
    self.noSedation = YES;
    self.startSedationDate = nil;
    self.endSedationDate = nil;
    [self showResults];
}

- (IBAction)addCodesAction:(id)sender {
    self.time = [self.timeTextField.text integerValue];
    self.canceled = NO;
    self.noSedation = NO;
    self.sameMD = [self.sameMDSwitch isOn];
    self.ageOver5 = [self.patientAgeSwitch isOn];
    [self showResults];
}

- (SedationStatus)determineSedationStatus {
    if (self.canceled) {
        return self.sedationStatus;
    }
    if (self.noSedation) {
        return None;
    }
    if (self.time < 10) {
        return LessThan10Mins;
    }
    if (!self.sameMD) {
        return OtherMDCalculated;
    }
    else {
        return AssignedSameMD;
    }
}

- (void)showResults {
    NSArray *sedationCodes = [EPSSedationCode sedationCoding:self.time sameMD:self.sameMD patientOver5:self.ageOver5];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sedation Coding" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){    [self.navigationController popViewControllerAnimated:YES];}];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    self.sedationStatus = [self determineSedationStatus];
    switch (self.sedationStatus) {
        case None:
            alert.message = @"No sedation used during this procedure.  No sedation codes added.";
            break;
        case LessThan10Mins:
            alert.message = @"Sedation time < 10 minutes.  No sedation codes can be added.";
            break;
        case OtherMDCalculated:
            alert.message = [NSString stringWithFormat:@"Sedation codes will need to be reported by MD administering sedation, not by MD performing procedure.\n\n%@", [EPSSedationCode printSedationCodesWithDescriptions:sedationCodes]];
            break;
        case AssignedSameMD:
            alert.message = [NSString stringWithFormat:@"%@", [EPSSedationCode printSedationCodesWithDescriptions:sedationCodes]];;
            break;
        case Unassigned:    // should not happenß®
        default:
            alert.message = @"Undefined sedation coding error.";
    }
    [self presentViewController:alert animated:YES completion:nil];
}

// MARK: textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

@end
