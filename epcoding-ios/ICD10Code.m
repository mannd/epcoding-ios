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

+ (ICD10Code *)fileNotFoundICD10Code {
    ICD10Code *code = [[ICD10Code alloc] initWithNumber:@"Error" description:@"Could not open ICD 10 code list file"];
    return code;
}


- (id)initWithNumber:(NSString *)number description:(NSString *)description {
    if (self = [super init]) {
        self.number = number;
        self.fullDescription = description;
    }
    return self;
}

// assumes valid string > 7 chars long!!
- (id)initWithString:(NSString *)string {
    if (self = [super init]) {
        NSString *rawNumber = [[string substringToIndex:6] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSMutableString *processedNumber = [NSMutableString stringWithString:rawNumber];
        if ([processedNumber length] > 3) {
            [processedNumber insertString:@"." atIndex:3];
        }
        NSString *description = [[string substringFromIndex:8] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self = [self initWithNumber:[NSString stringWithString:processedNumber] description:description];
    }
    return self;
}


@end
