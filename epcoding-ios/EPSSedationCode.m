//
//  EPSSedationCode.m
//  EP Coding
//
//  Created by David Mann on 2/19/17.
//  Copyright © 2017 David Mann. All rights reserved.
//

#import "EPSSedationCode.h"
#import "EPSCodes.h"

@implementation EPSSedationCode

{
    NSMutableArray *sedationCodes;
}

- (id)initWithNumber:(NSString *)number description:(NSString *)description isAddOn:(BOOL)isAddOn {
    if (self = [super initWithNumber:number description:description isAddOn:isAddOn]) {
        self.sedationStatus = Unassigned;
        self.code1 = nil;
        self.code2 = nil;
        sedationCodes = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)init {
    self = [self initWithNumber:@"SEDATION CODING" description:UNASSIGNED_SEDATION_STRING isAddOn:NO];
    return self;
}

- (NSString *)unformattedCodeDescription {
    [sedationCodes removeAllObjects];
    if (self.code1 != nil) {
        [sedationCodes addObject:self.code1];
        if (self.code2 != nil) {
            [sedationCodes addObject:self.code2];
        }
    }
    NSString *detail = [EPSCodes sedationDetail:sedationCodes sedationStatus:self.sedationStatus];
    return detail;
}

@end
