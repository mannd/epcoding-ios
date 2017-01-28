//
//  EPSSedationViewController.h
//  EP Coding
//
//  Created by David Mann on 1/28/17.
//  Copyright © 2017 David Mann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPSSedationViewController : UIViewController
- (IBAction)SameMDAction:(id)sender;
- (IBAction)patientAgeAction:(id)sender;
- (IBAction)timeStepperAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIStepper *timeStepper;
@property (strong, nonatomic) IBOutlet UITextField *sedationTime;

@end
