//
//  EPSDateTimeCalculatorTableViewController.h
//  epcoding-ios
//
//  Created by David Mann on 10/31/17.
//  Copyright © 2017 David Mann. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol sendTimeDataProtocol <NSObject>

-(void)sendTimeDataBack:(BOOL)canceled sedationTime:(NSInteger)time;

@end


@interface EPSDateTimeCalculatorTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableViewCell *startCell;
@property (strong, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (strong, nonatomic) IBOutlet UITableViewCell *endCell;
@property (strong, nonatomic) IBOutlet UIDatePicker *endDatePicker;

@property BOOL startDatePickerVisible;
@property BOOL endDatePickerVisible;
@property NSInteger time;
@property(nonatomic,assign)id delegate;

- (IBAction)startDateChanged:(id)sender;
- (IBAction)endDateChanged:(id)sender;

@end
