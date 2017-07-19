//
//  ICD10Code.m
//  EP Coding
//
//  Created by David Mann on 7/19/17.
//  Copyright © 2017 David Mann. All rights reserved.
//

#import "ICD10Code.h"

@implementation ICD10Code

+ (NSString *)processRawNumber:(NSString *)rawCodeNumber {
    // assumes well formatted ICD10 code number, e.g. X000000
    if (rawCodeNumber == nil || rawCodeNumber.length < 4) {
        return rawCodeNumber;
    }
    NSMutableString *result = [NSMutableString stringWithString:rawCodeNumber];
    [result insertString:@"." atIndex:3];
    return [NSString stringWithString:result];
}


@end
