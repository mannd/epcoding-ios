//
//  EPSSedationViewController.m
//  EP Coding
//
//  Created by David Mann on 1/28/17.
//  Copyright © 2017 David Mann. All rights reserved.
//

#import "EPSSedationViewController.h"
#import "EPSTimeCalculatorViewController.h"

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
    self.timeTextField.text = [NSString stringWithFormat:@"%lu", self.time];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
    UIBarButtonItem *addCodesButton = [[ UIBarButtonItem alloc ] initWithTitle: @"Add Codes" style: UIBarButtonItemStylePlain target: self action: @selector(addCodesAction:)];
    self.toolbarItems = [ NSArray arrayWithObjects: cancelButton, addCodesButton, nil];

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
    NSLog(@"time = %lu", time);
    NSLog(@"cancel = %d", canceled);
    if (canceled) {
        return;
    }
    self.time = time;
    self.timeTextField.text = [NSString stringWithFormat:@"%lu", time];
}


- (IBAction)SameMDAction:(id)sender {
}

- (IBAction)patientAgeAction:(id)sender {
}

-(void)viewWillDisappear:(BOOL)animated
{
    NSInteger time = [self.timeTextField.text integerValue];
    [self.delegate sendSedationDataBack:self.canceled samePhysician:self.sameMDSwitch.isOn lessThan5:!self.patientAgeSwitch.isOn sedationTime:time];
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.timeTextField resignFirstResponder];
}

- (IBAction)cancelAction:(id)sender {
    self.canceled = YES;
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)addCodesAction:(id)sender {
    if (![self.timeTextField.text integerValue]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Time not a number" message:@"Time must be a positive whole number." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAlert = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAlert];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    self.canceled = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

@end
