//
//  EPSSedationViewController.m
//  EP Coding
//
//  Created by David Mann on 1/28/17.
//  Copyright © 2017 David Mann. All rights reserved.
//

#import "EPSSedationViewController.h"
#import "EPSTimeCalculatorViewController.h"
#import "EPSCodes.h"
#import "EPSSedationCode.h"

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
    self.toolbarItems = [ NSArray arrayWithObjects: cancelButton, noSedationButton, addCodesButton, nil];
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
    if ([[segue identifier] isEqualToString:@"showTimeCalculator"]) {
        EPSTimeCalculatorViewController *viewController = segue.destinationViewController;
        viewController.delegate = self;
    }
}

-(void)sendTimeDataBack:(BOOL)canceled sedationTime:(NSInteger)time;
{
    if (canceled) {
        return;
    }
    self.time = time;
    self.timeTextField.text = [NSString stringWithFormat:@"%lu", (long)time];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.delegate sendSedationDataBack:self.canceled samePhysician:self.sameMD lessThan5:!self.ageOver5 sedationTime:self.time noSedation:self.noSedation sedationStatus:self.sedationStatus];
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
    [self showResults];
}

- (IBAction)addCodesAction:(id)sender {
//    // if time is zero or not an integer or if not same MD performing then give error message
//    if (![self.timeTextField.text integerValue] && [self.sameMDSwitch isOn]) {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sedation Time Error" message:@"Time must be a number more than 0.  If no sedation was performed, choose No Sedation button instead." preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *cancelAlert = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
//        [alert addAction:cancelAlert];
//        [self presentViewController:alert animated:YES completion:nil];
//        return;
//    }
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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sedation Results" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){    [self.navigationController popViewControllerAnimated:YES];}];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    self.sedationStatus = [self determineSedationStatus];
    if (self.sedationStatus == None) {
        alert.message = @"No sedation used during this procedure.  No sedation codes added.";
    }
    else if (self.sedationStatus == LessThan10Mins) {
        alert.message = @"Sedation time < 10 minutes.  No sedation codes can be added.";
    }
    else if (self.sedationStatus == OtherMDUnCalculated) {
        alert.message = @"Sedation administered by different MD than one performing procedure.  No sedation time given.  No sedation codes added.";
    }
    else if (self.sedationStatus == OtherMDCalculated) {
        if ([sedationCodes count] == 1) {
            alert.message = [NSString stringWithFormat:@"Sedation codes will need to be reported by MD administering sedation, not by MD performing procedure.  Sedation code that MD adminstering sedation should add is %@.", [EPSSedationCode printSedationCodes:sedationCodes separator:@""]];
        }
        else {
            alert.message = [NSString stringWithFormat:@"Sedation codes will need to be reported by MD administering sedation, not by MD performing procedure.  Sedation codes that MD adminstering sedation should add are %@.", [EPSSedationCode printSedationCodes:sedationCodes separator:@" and "]];
        }
    }
    else {  // self.sedationStatus == AssignedSameMD
        if ([sedationCodes count] == 1) {
            alert.message = [NSString stringWithFormat:@"Sedation code added: %@.", [EPSSedationCode printSedationCodes:sedationCodes separator:@""]];
        }
        else {
            alert.message = [NSString stringWithFormat:@"Sedation codes added: %@.", [EPSSedationCode printSedationCodes:sedationCodes separator:@" and "]];
        }
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
