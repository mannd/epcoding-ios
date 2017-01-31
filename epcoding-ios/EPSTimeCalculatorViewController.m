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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    UIBarButtonItem *calculateButton = [[ UIBarButtonItem alloc ] initWithTitle: @"Calculate" style: UIBarButtonItemStylePlain target: self action: @selector(calculate)];
    self.toolbarItems = [ NSArray arrayWithObjects: cancelButton, calculateButton, nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    NSInteger time = self.time;
    [self.delegate sendTimeDataBack:time];
}

- (void)cancel {
    
}

- (void)calculate {
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
