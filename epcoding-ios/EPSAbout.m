//
//  EPSAbout.m
//  EP Coding
//
//  Created by David Mann on 6/4/17.
//  Copyright © 2017 David Mann. All rights reserved.
//

#import "EPSAbout.h"
#import <UIKit/UIKit.h>

@implementation EPSAbout

+ (void)show:(UIViewController *)vc {
    NSString *details = [[NSString alloc] initWithFormat: @"Copyright \u00a9 2013-2021 EP Studios, Inc.\nAll rights reserved.\nVersion %@" , [self getVersion]];
    NSString *title = @"EP Coding";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:details preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [vc presentViewController:alert animated:YES completion:nil];
}

+ (NSString *)getVersion {
    NSDictionary *dictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = dictionary[@"CFBundleShortVersionString"];
#ifdef DEBUG // Get build number, if you want it. Cleaner to leave out of release version.
    NSString *build = dictionary[@"CFBundleVersion"];
    // the version+build format is recommended by https://semver.org
    NSString *versionBuild = [NSString stringWithFormat:@"%@+%@", version, build];
    return versionBuild;
#else
    return version;
#endif
}


@end
