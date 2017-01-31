//
//  EPSTimeCalculatorViewController.h
//  EP Coding
//
//  Created by David Mann on 1/30/17.
//  Copyright © 2017 David Mann. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol sendDataProtocol <NSObject>

-(void)sendTimeDataBack:(NSInteger)time;

@end


@interface EPSTimeCalculatorViewController : UIViewController

@property NSInteger time;
@property(nonatomic,assign)id delegate;

@end
