//
//  EPSCodeAnalyzer.m
//  EP Coding
//
//  Created by David Mann on 3/1/14.
//  Copyright (c) 2014 David Mann. All rights reserved.
//

#import "EPSCodeAnalyzer.h"
#import "EPSCode.h"
#import "EPSCodeError.h"

//#define WARNING @"\u26A0"
//#define ERROR @"\u620"
//#define OK @"\u263A"

@implementation EPSCodeAnalyzer

- (id)initWithPrimaryCodes:(NSArray *)primaryCodes secondaryCodes:(NSArray *)secondaryCodes ignoreNoSecondaryCodes:(BOOL)ignoreNoSecondaryCodes
{
    if ([super init]) {
        self.primaryCodes = primaryCodes;
        self.secondaryCodes = secondaryCodes;
        self.ignoreNoSecondaryCodes = ignoreNoSecondaryCodes;
    }
    return self;
}

// If you do analysis first, proper status will be set on these codes, otherwise all
// default to OK.
- (NSArray *)allCodes
{
    NSArray *array = [self.primaryCodes arrayByAddingObjectsFromArray:self.secondaryCodes];
    return array;
}

// analyzer uses code numbers for analysis
- (NSArray *)allCodeNumbers
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSArray *allCodes = [self allCodes];
    for (EPSCode *code in allCodes) {
        [array addObject:[code number]];
    }
    return array;
}

- (NSArray *)analysis
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if ([self.primaryCodes count] == 0 && [self.secondaryCodes count] == 0) {
        [array addObject:[[EPSCodeError alloc] initWithCodes:nil withWarningLevel:WARNING withMessage:@"No codes selected."]];
        return array;
    }
    if ([self.primaryCodes count] == 0) {
        [array addObject:[[EPSCodeError alloc] initWithCodes:nil withWarningLevel:ERROR withMessage:@"No primary codes selected.  You shouldn't just have additional codes selected."]];
    }
    
    if ([array count] == 0)
        [array addObject:[[EPSCodeError alloc] initWithCodes:nil withWarningLevel:GOOD withMessage:@"No errors or warnings."]];

    return array;
}

- (BOOL)allAddOnCodes
{
    BOOL allAddOns = YES;
    for (EPSCode *code in [self allCodes]) {
        if (![code isAddOn]) {
            allAddOns = NO;
        }
    }
    return allAddOns;
}




@end
