//
//  EPSUtilities.m
//  epcoding-ios
//
//  Created by David Mann on 9/11/19.
//  Copyright © 2019 David Mann. All rights reserved.
//

#import "EPSUtilities.h"

#define FLEX_SPACE [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]

@implementation EPSUtilities

+ (NSArray *)spaceoutToolbar:(NSArray *)items {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < items.count; i++) {
        if (i == 0) {
            array[0] = items[0];
        }
        else {
            [array addObject:FLEX_SPACE];
            [array addObject:items[i]];
        }
    }
    return array;
}

@end
