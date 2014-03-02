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

+ (NSSet *)ablationCodeNumberSet
{
    static NSSet* set;
    if (set == nil) {
        set = [[NSSet alloc] initWithArray:@[@"93653", @"93656"]];
    }
    return set;
}

+ (NSSet *)mappingCodeNumberSet
{
    static NSSet *set;
    if (set == nil) {
        set = [[NSSet alloc] initWithArray:@[@"93609", @"93613"]];
    }
    return set;
}

+ (NSArray *)duplicateCodeErrors
{
    static NSMutableArray *array;
    if (array == nil) {
        // duplicate mapping codes
        [array addObject:[[EPSCodeError alloc] initWithCodes:[NSMutableArray arrayWithArray:@[@"93609", @"93613"]] withWarningLevel:ERROR withMessage:@"You shouldn't combine 2D and 3D mapping codes."]];
    }
    return array;
}

// analyzer uses code numbers for analysis
- (NSArray *)allCodeNumbers
{
    return [self codeNumbersFromCodes:[self allCodes]];
}

- (NSSet *)allCodeNumberSet
{
    return [[NSSet alloc] initWithArray:[self allCodeNumbers]];
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
    // Note quick exit if no codes selected
    if ([self.primaryCodes count] == 0 && [self.secondaryCodes count] == 0) {
        [array addObject:[[EPSCodeError alloc] initWithCodes:nil withWarningLevel:WARNING withMessage:@"No codes selected."]];
        return array;
    }
    if ([self.primaryCodes count] == 0) {
        [array addObject:[[EPSCodeError alloc] initWithCodes:nil withWarningLevel:ERROR withMessage:@"No primary codes selected.  All codes are additional codes."]];
        [self markCodes:self.allCodes withWarning:ERROR];
    }
    if ([self allAddOnCodes]) {
        [array addObject:[[EPSCodeError alloc] initWithCodes:nil withWarningLevel:ERROR withMessage:@"All codes are add-on codes which should only be added to primary codes."]];
        [self markCodes:self.allCodes withWarning:ERROR];
    }
    if ([self.secondaryCodes count] == 0 && !self.ignoreNoSecondaryCodes) {
        [array addObject:[[EPSCodeError alloc] initWithCodes:nil withWarningLevel:WARNING withMessage:@"No additional codes selected.  Be certain you aren't overlooking other codes."]];
        [self markCodes:self.allCodes withWarning:WARNING];
    }
    if ([self noMappingCodesForAblation]) {
        [array addObject:[[EPSCodeError alloc] initWithCodes:nil withWarningLevel:WARNING withMessage:@"No mapping codes for ablation.  You should be able to code 2D or 3D mapping."]];
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

- (BOOL)noMappingCodesForAblation
{
    BOOL noMappingCodes = YES;
    BOOL hasAblationCodes = NO;
    for (NSString * codeNumber in [self allCodeNumbers]) {
        if ([[EPSCodeAnalyzer ablationCodeNumberSet] containsObject:codeNumber]) {
            hasAblationCodes = YES;
        }
        if ([[EPSCodeAnalyzer mappingCodeNumberSet] containsObject:codeNumber]) {
            noMappingCodes = NO;
        }
    }
    return hasAblationCodes && noMappingCodes;
}

- (NSArray *)combinationCodeNumberErrors
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (EPSCodeError *codeError in [EPSCodeAnalyzer duplicateCodeErrors]) {
        NSArray *badCombo = codeError.codes;
        
    }
    return array;
}

// returns list of matching bad codes
- (NSArray *)hasBadComboWithCodeNumberSet:(NSSet *)codeNumberSet andBadCodeNumbers:(NSArray *)badCodeNumbers
{
    NSMutableArray *badCodeNumberArray = [[NSMutableArray alloc] init];
    for (NSString *badCodeNumber in badCodeNumbers) {
        if ([codeNumberSet containsObject:badCodeNumber]) {
            [badCodeNumberArray addObject:badCodeNumber];
        }
    }
    return badCodeNumberArray;
}

// return code numbers formated like this "[99999, 99991]"
- (NSString *)codeNumbersToString:(NSArray *)codeNumbers
{
    NSString *string = [codeNumbers componentsJoinedByString:@","];
    return [NSString stringWithFormat:@"[%@] ", string];
}





@end
