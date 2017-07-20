//
//  EPSAbout.m
//  EP Coding
//
//  Created by David Mann on 6/4/17.
//  Copyright © 2017 David Mann. All rights reserved.
//

#import "EPSAbout.h"
#import <UIKit/UIKit.h>

// TODO: update version
#define VERSION @"1.8"

@implementation EPSAbout

+ (void)show:(UIViewController *)vc {
    NSString *details = [[NSString alloc] initWithFormat: @"Copyright \u00a9 2014-2017 EP Studios, Inc.\nAll rights reserved.\nVersion %@" , VERSION];
    NSString *title = @"EP Coding";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:details preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [vc presentViewController:alert animated:YES completion:nil];
}



@end
