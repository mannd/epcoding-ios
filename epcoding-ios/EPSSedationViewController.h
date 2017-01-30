//
//  EPSSedationViewController.h
//  EP Coding
//
//  Created by David Mann on 1/28/17.
//  Copyright © 2017 David Mann. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol sendDataProtocol <NSObject>

-(void)sendSedationDataBack:(BOOL)cancel samePhysician:(BOOL)sameMD lessThan5:(BOOL)lessThan5 sedationTime:(NSInteger)time;

@end

@interface EPSSedationViewController : UIViewController <UITextFieldDelegate>
- (IBAction)SameMDAction:(id)sender;
- (IBAction)patientAgeAction:(id)sender;
@property (strong, nonatomic) IBOutlet UISwitch *sameMDSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *patientAgeSwitch;
@property (strong, nonatomic) IBOutlet UITextField *timeTextField;

@property BOOL canceled;
@property BOOL sameMD;
@property BOOL ageOver5;
@property NSInteger time;

- (IBAction)dismissKeyboard:(id)sender;




- (IBAction)cancelAction:(id)sender;
- (IBAction)addCodesAction:(id)sender;

@property(nonatomic,assign)id delegate;

@end
