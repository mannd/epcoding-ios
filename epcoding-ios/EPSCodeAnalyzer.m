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
        NSMutableArray *array = [NSMutableArray  arrayWithArray:[self.primaryCodes arrayByAddingObjectsFromArray:self.secondaryCodes]];
        self.allCodes = array;
    }
    return self;
}

// analyzer uses code numbers for analysis
- (NSArray *)allCodeNumbers
{
    return [self codeNumbersFromCodes:[self allCodes]];
}

- (NSArray *)codeNumbersFromCodes:(NSArray *)codes
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (EPSCode *code in codes) {
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
        [array addObject:[[EPSCodeError alloc] initWithCodes:nil withWarningLevel:ERROR withMessage:@"No primary codes selected.  All codes are other codes."]];
        [self markCodes:self.allCodes withWarning:ERROR];
    }
    if ([self.secondaryCodes count] == 0 && !self.ignoreNoSecondaryCodes) {
        [array addObject:[[EPSCodeError alloc] initWithCodes:nil withWarningLevel:WARNING withMessage:@"No other codes selected.  This is ok but be certain you aren't other codes."]];
        [self markCodes:self.allCodes withWarning:WARNING];
    }
    
    if ([array count] == 0)
        [array addObject:[[EPSCodeError alloc] initWithCodes:nil withWarningLevel:GOOD withMessage:@"No errors or warnings."]];

    return array;
}

- (void)markCodes:(NSMutableArray *)codes withWarning:(enum status)level
{
    for (EPSCode *code in codes) {
        [code markCodeStatus:level];
    }
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

// return code numbers formated like this "[99999, 99991]"
- (NSString *)codeNumbersToString:(NSArray *)codeNumbers
{
    NSString *string = [codeNumbers componentsJoinedByString:@","];
    return [NSString stringWithFormat:@"[%@] ", string];
}





@end
