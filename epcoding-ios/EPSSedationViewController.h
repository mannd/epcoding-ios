//
//  EPSSedationViewController.h
//  EP Coding
//
//  Created by David Mann on 1/28/17.
//  Copyright © 2017 David Mann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EPSCodes.h"
#import "EPSSedationCode.h"

@protocol sendDataProtocol <NSObject>

-(void)sendSedationDataBack:(BOOL)cancel samePhysician:(BOOL)sameMD lessThan5:(BOOL)lessThan5 sedationTime:(NSInteger)time noSedation:(BOOL)noSedation sedationStatus:(SedationStatus)sedationStatus;

@end

@interface EPSSedationViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UISwitch *sameMDSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *patientAgeSwitch;
@property (strong, nonatomic) IBOutlet UITextField *timeTextField;

@property BOOL canceled;
@property BOOL sameMD;
@property BOOL ageOver5;
@property NSInteger time;
@property BOOL noSedation;
@property SedationStatus sedationStatus;

- (IBAction)dismissKeyboard:(id)sender;



- (IBAction)noSedationAction:(id)sender;
- (IBAction)cancelAction:(id)sender;
- (IBAction)addCodesAction:(id)sender;

@property(nonatomic,assign)id delegate;

@end
