//
//  EPSCodeAnalyzer.m
//  EP Coding
//
//  Created by David Mann on 3/1/14.
//  Copyright (c) 2014 David Mann. All rights reserved.
//

#import "EPSCodeAnalyzer.h"
#import "EPSCode.h"
#import "EPSCodes.h"
#import "EPSCodeError.h"


#define DEFAULT_DUPLICATE_ERROR @"These codes shouldn't be combined."

@implementation EPSCodeAnalyzer

- (id)initWithPrimaryCodes:(NSArray *)primaryCodes secondaryCodes:(NSArray *)secondaryCodes ignoreNoSecondaryCodes:(BOOL)ignoreNoSecondaryCodes sedationCodes:(NSArray *)sedationCodes sedationStatus:(SedationStatus)sedationStatus
{
    if (self = [super init]) {
        self.primaryCodes = primaryCodes;
        self.secondaryCodes = secondaryCodes;
        self.sedationCodes = sedationCodes;
        self.ignoreNoSecondaryCodes = ignoreNoSecondaryCodes;
        NSMutableArray *array = [NSMutableArray  arrayWithArray:[self.primaryCodes arrayByAddingObjectsFromArray:self.secondaryCodes]];
        [array addObjectsFromArray:self.sedationCodes];
        self.allCodes = array;
        self.sedationStatus = sedationStatus;
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

// This can't be a static method, as it needs to be recreated each go around.
// If it is static, the changes to the CodeErrors persist.
- (NSArray *)duplicateCodeErrors
{
    // duplicate mapping codes
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[[EPSCodeError alloc] initWithCodes:[NSMutableArray arrayWithArray:@[@"93609", @"93613"]] withWarningLevel:ERROR withMessage:@"You shouldn't combine 2D and 3D mapping codes."]];
    [array addObject:[[EPSCodeError alloc] initWithCodes:[NSMutableArray arrayWithArray:@[@"92960", @"92961"]] withWarningLevel:ERROR withMessage:@"You can't code for both internal and external cardioversion."]];
    [array addObject:[[EPSCodeError alloc] initWithCodes:[NSMutableArray arrayWithArray:@[@"33206", @"33207", @"33208", @"33227", @"33228", @"33229"]] withWarningLevel:ERROR withMessage:DEFAULT_DUPLICATE_ERROR]];
    [array addObject:[[EPSCodeError alloc] initWithCodes:[NSMutableArray arrayWithArray:@[@"33240", @"33230", @"33231", @"33262", @"33263", @"33264"]] withWarningLevel:ERROR withMessage:DEFAULT_DUPLICATE_ERROR]];
    [array addObject:[[EPSCodeError alloc] initWithCodes:[NSMutableArray arrayWithArray:@[@"93600", @"93619", @"93620", @"93655", @"93657"]] withWarningLevel:ERROR withMessage:DEFAULT_DUPLICATE_ERROR]];
    [array addObject:[[EPSCodeError alloc] initWithCodes:[NSMutableArray arrayWithArray:@[@"93653", @"93654", @"93656"]] withWarningLevel:ERROR withMessage:@"You can't combine primary ablation codes."]];
    [array addObject:[[EPSCodeError alloc] initWithCodes:[NSMutableArray arrayWithArray:@[@"33270", @"33271"]] withWarningLevel:ERROR withMessage:DEFAULT_DUPLICATE_ERROR]];
    [array addObject:[[EPSCodeError alloc] initWithCodes:[NSMutableArray arrayWithArray:@[@"0389T", @"0390T", @"0391T"]] withWarningLevel:ERROR withMessage:DEFAULT_DUPLICATE_ERROR]];
    
    return array;
}

- (NSArray *)specialFirstCodeErrors
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[[EPSCodeError alloc] initWithCodes:[NSMutableArray arrayWithArray:@[@"33233", @"33227", @"33228", @"33229", @"33213", @"33213",                                                                         @"33221"]] withWarningLevel:ERROR withMessage:@"Don't use generator removal and insertion or replacement codes together."]];
    [array addObject:[[EPSCodeError alloc] initWithCodes:[NSMutableArray arrayWithArray:@[@"33214", @"33227", @"33228", @"33229"]] withWarningLevel:ERROR withMessage:@"Don't use PPM upgrade code with generator replacement codes"]];
    [array addObject:[[EPSCodeError alloc] initWithCodes:[NSMutableArray arrayWithArray:@[@"93656", @"93621", @"93462"]] withWarningLevel:ERROR withMessage:@"Code(s) selected are already included in AFB Ablation."]];
    [array addObject:[[EPSCodeError alloc] initWithCodes:[NSMutableArray arrayWithArray:@[@"93653", @"93657"]] withWarningLevel:ERROR withMessage:@"AFB Ablation should not be added on to SVT ablation.  Use AFB ablation as the primary code."]];
    [array addObject:[[EPSCodeError alloc] initWithCodes:[NSMutableArray arrayWithArray:@[@"93654", @"93657", @"93609", @"93613", @"93622"]] withWarningLevel:ERROR withMessage:@"Code(s) cannot be add to VT Ablation."]];
    [array addObject:[[EPSCodeError alloc] initWithCodes:[NSMutableArray arrayWithArray:@[@"93650", @"93609", @"93613"]] withWarningLevel:WARNING withMessage:@"It is not clear if mapping codes can be combined with AV node ablaton."]];
    [array addObject:[[EPSCodeError alloc] initWithCodes:[NSMutableArray arrayWithArray:@[@"93650", @"93600", @"93619", @"93620"]] withWarningLevel:WARNING withMessage:@"It is unclear if AV node ablation can be combined with EP testing codes."]];
    [array addObject:[[EPSCodeError alloc] initWithCodes:[NSMutableArray arrayWithArray:@[@"93623", @"93650", @"93653", @"93654", @"93656"]] withWarningLevel:WARNING withMessage:@"Recent coding changes may disallow bundling induce post IV drug with ablation."]];

    
    return array;
}

- (NSArray *)firstCodeNeedsOthersErrors
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[[EPSCodeError alloc] initWithCodes:[NSMutableArray arrayWithArray:@[@"33225", @"33206", @"33207", @"33208", @"33249", @"33214"]] withWarningLevel:ERROR withMessage:@"Must use 33225 with new device implant code"]];
    
    return array;
}

// TODO: sedation code logic
// warning if only sedation codes chosen if they are same physician as procedural MD
// warning if no sedation codes chosen
// warning if other physician sedation codes chosen
- (NSArray *)badSedationCodeErrors
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[[EPSCodeError alloc] initWithCodes:[NSMutableArray arrayWithArray:@[@"99115", @"99156", @"99157"]] withWarningLevel:ERROR withMessage:@"Sedation code(s) for another MD can't be charged by MD performing procedure."]];
    return array;
}

// analyzer uses code numbers for analysis
- (NSArray *)allCodeNumbers
{
    return [self codeNumbersFromCodes:[self allCodes]];
}

- (NSSet *)allCodeNumberSet
{
    return[[NSSet alloc] initWithArray:[self allCodeNumbers]];
}

- (NSArray *)codeNumbersFromCodes:(NSArray *)codes
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (EPSCode *code in codes) {
        [array addObject:[code number]];
    }
    return array;
}

- (NSSet *)initialSedationCodeSet {
    return [[NSSet alloc] initWithObjects:@"99151", @"99152", @"99155", @"99156", nil];
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
        [array addObject:[[EPSCodeError alloc] initWithCodes:nil withWarningLevel:WARNING withMessage:@"No mapping codes for ablation."]];
        [self markCodes:self.allCodes withWarning:WARNING];
    }
    // warn for no sedation codes
//    if ([self mismatchedSedationCodes] == 1) {
//        [array addObject:[[EPSCodeError alloc] initWithCodes:nil withWarningLevel:WARNING withMessage:@"No sedation codes.  Did you provide sedation services?  Sedation codes are no longer bundled with the procedure codes [2017]."]];
//        [self markCodes:self.allCodes withWarning:WARNING];
//    }
    
    [array addObjectsFromArray:[self evaluateSedationStatus]];
    
    NSArray *duplicateCodeErrors = [self combinationCodeNumberErrors];
    [array addObjectsFromArray:duplicateCodeErrors];
    NSArray *firstSpecialCodeErrors = [self firstSpecialCodeNumberErrors];
    [array addObjectsFromArray:firstSpecialCodeErrors];
    NSArray *firstNeedsOthersCodeErrors = [self firstNeedsOthersCodeNumberErrors];
    [array addObjectsFromArray:firstNeedsOthersCodeErrors];
    
    if ([array count] == 0)
        [array addObject:[[EPSCodeError alloc] initWithCodes:nil withWarningLevel:GOOD withMessage:@"No errors or warnings."]];

    return array;
}

- (void)markCodes:(NSArray *)codes withWarning:(enum status)level
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
    NSSet *codeNumberSet = [self allCodeNumberSet];
    for (EPSCodeError *codeError in [self duplicateCodeErrors]) {
        NSArray *badCombo = codeError.codes;
        NSArray *badCodeList = [self codesWithBadCombosFromCodeSet:codeNumberSet
                                                 andBadCodeNumbers:badCombo];
        if ([badCodeList count] > 1) {
            NSArray *codes = [EPSCodes getCodesForCodeNumbers:badCodeList];
            [self markCodes:codes withWarning:[codeError warningLevel]];
            codeError.codes = [NSMutableArray arrayWithArray:badCodeList];
            [array addObject:codeError];
        }
    }
    return array;
}

// This tests for errors where a single code should not be used with
// multiple other codes. E.g. PPM removal should not be used with any of the
// specially, i.e. skips testing if the first number is not present
- (NSArray *)firstSpecialCodeNumberErrors
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSSet *codeNumberSet = [self allCodeNumberSet];
    for (EPSCodeError* codeError in [self specialFirstCodeErrors]) {
        NSArray *badCombo = codeError.codes;
        if ([codeNumberSet containsObject:[badCombo objectAtIndex:0]]) {
            NSArray *badCodeList = [self codesWithBadCombosFromCodeSet:codeNumberSet
                                                     andBadCodeNumbers:badCombo];
            if ([badCodeList count] > 1) {
                NSArray *codes = [EPSCodes getCodesForCodeNumbers:badCodeList];
                [self markCodes:codes withWarning:[codeError warningLevel]];
                codeError.codes = [NSMutableArray arrayWithArray:badCodeList];
                [array addObject:codeError];
            }

        }
    }
    return array;
}

// This tests to see if at least one necessary accompanying code is present
// if first code is present
- (NSArray *)firstNeedsOthersCodeNumberErrors
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSSet *codeNumberSet = [self allCodeNumberSet];
    for (EPSCodeError* codeError in [self firstCodeNeedsOthersErrors]) {
        NSArray *badCombo = codeError.codes;
        if ([codeNumberSet containsObject:[badCombo objectAtIndex:0]]) {
            NSArray *badCodeList = [self codesWithBadCombosFromCodeSet:codeNumberSet
                                                     andBadCodeNumbers:badCombo];
            if ([badCodeList count] == 1) { // oops only first code present
                NSArray *codes = [EPSCodes getCodesForCodeNumbers:badCodeList];
                [self markCodes:codes withWarning:[codeError warningLevel]];
                codeError.codes = [NSMutableArray arrayWithArray:badCodeList];
                [array addObject:codeError];
            }
        }
    }
    
    return array;
}

// returns list of matching bad codes
- (NSArray *)codesWithBadCombosFromCodeSet:(NSSet *)codeNumberSet andBadCodeNumbers:(NSArray *)badCodeNumbers
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
+ (NSString *)codeNumbersToString:(NSArray *)codeNumbers
{
    if (codeNumbers == nil || [codeNumbers count] == 0) {
        return nil;
    }
    NSString *string = [codeNumbers componentsJoinedByString:@","];
    return [NSString stringWithFormat:@"[%@]", string];
}

- (NSArray *)evaluateSedationStatus {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    switch (self.sedationStatus) {
        case Unassigned:
            [array addObject:[[EPSCodeError alloc] initWithCodes:nil withWarningLevel:WARNING withMessage:@"No sedation codes.  Did you provide sedation services?  Sedation codes are no longer bundled with the procedure codes."]];
            [self markCodes:self.allCodes withWarning:WARNING];
            break;
        case None:
            [array addObject:[[EPSCodeError alloc] initWithCodes:nil withWarningLevel:GOOD withMessage:@"Procedure was performed without sedation."]];
            [self markCodes:self.allCodes withWarning:GOOD];
            break;
        case LessThan10Mins:
            [array addObject:[[EPSCodeError alloc] initWithCodes:nil withWarningLevel:GOOD withMessage:@"No sedation coding as sedation time was < 10 minutes."]];
            [self markCodes:self.allCodes withWarning:GOOD];
            break;
        case OtherMDCalculated:
            [array addObject:[[EPSCodeError alloc] initWithCodes:nil withWarningLevel:WARNING withMessage:@"Sedation performed by other MD and must be submitted by that MD."]];
            [self markCodes:self.sedationCodes withWarning:WARNING];
            break;
        case AssignedSameMD:
            // no warnings, everything good
            break;
    }
    return array;
}

@end
