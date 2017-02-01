//
//  EPSTimeCalculatorViewController.h
//  EP Coding
//
//  Created by David Mann on 1/30/17.
//  Copyright © 2017 David Mann. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol sendTimeDataProtocol <NSObject>

-(void)sendTimeDataBack:(BOOL)canceled sedationTime:(NSInteger)time;

@end


@interface EPSTimeCalculatorViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)datePickerChanged:(id)sender;

@property (strong, nonatomic) IBOutlet UISegmentedControl *timeSegmentedControl;
- (IBAction)timeControlChanged:(id)sender;

@property NSInteger time;
@property(nonatomic,assign)id delegate;

@end
