//
//  EPSSedationCode.m
//  EP Coding
//
//  Created by David Mann on 2/19/17.
//  Copyright © 2017 David Mann. All rights reserved.
//

#import "EPSSedationCode.h"
#import "EPSCodes.h"

NSString *const SEDATION_CODE_NUMBER = @"Sedation Coding";
NSString *const NO_SEDATION_STRING = @"No sedation used during this procedure.";
NSString *const UNASSIGNED_SEDATION_STRING = @"No sedation codes assigned.";
NSString *const SHORT_SEDATION_TIME_STRING = @"No codes assigned as sedation time < 10 mins.";
NSString *const OTHER_MD_UNCALCULATED_SEDATION_TIME_STRING = @"Sedation performed by other MD.";
NSString *const OTHER_MD_CALCULATED_SEDATION_TIME_STRING = @"Sedation performed by other MD, who should use coding %@";

@implementation EPSSedationCode

- (id)initWithNumber:(NSString *)number description:(NSString *)description isAddOn:(BOOL)isAddOn {
    if (self = [super initWithNumber:number description:description isAddOn:isAddOn]) {
        self.sedationStatus = Unassigned;
        self.sedationCodes = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)init {
    self = [self initWithNumber:SEDATION_CODE_NUMBER description:UNASSIGNED_SEDATION_STRING isAddOn:NO];
    return self;
}

- (NSString *)unformattedCodeDescription {
    NSString *detail = [EPSSedationCode sedationDetail:self.sedationCodes sedationStatus:self.sedationStatus];
    return detail;
}

+ (NSArray *)sedationCoding:(NSInteger)sedationTime sameMD:(BOOL)sameMD patientOver5:(BOOL)patientOver5 {
    NSMutableArray *codes = [[NSMutableArray alloc] init];
    if (sedationTime >= 10) {
        if (sameMD) {
            if (patientOver5) {
                [codes addObject:[EPSCodes getCodeForNumber:@"99152"]];
            }
            else {
                [codes addObject:[EPSCodes getCodeForNumber:@"99151"]];
            }
        }
        else {
            if (patientOver5) {
                [codes addObject:[EPSCodes getCodeForNumber:@"99156"]];
            }
            else {
                [codes addObject:[EPSCodes getCodeForNumber:@"99155"]];
            }
        }
    }
    if (sedationTime >= 23) {
        NSInteger multiplier = [self codeMultiplier:sedationTime];
        EPSCode *code = [[EPSCode alloc] init];
        if (sameMD) {
            code = [EPSCodes getCodeForNumber:@"99153"];
        }
        else {
            code = [EPSCodes getCodeForNumber:@"99157"];
        }
        code.multiplier = multiplier;
        [codes addObject:code];
    }
    return codes;
}

+ (NSUInteger)codeMultiplier:(NSInteger)time {
    if (time <= 22)
        return 0;
    float multiplier = (time - 15) / 15.0;
    multiplier = roundf(multiplier);
    return (NSUInteger)multiplier;
}

+ (NSString *)printSedationCodesWithDescriptions:(NSArray *)codes {
    NSString *codeString = @"";
    if (codes == nil || [codes count] < 1) {
        return codeString;
    }
    if ([codes count ] == 1) {
        codeString = [[codes objectAtIndex:0] unformattedCodeNumberFirst];
    }
    else {
        codeString = [NSString stringWithFormat:@"%@\n%@", [[codes objectAtIndex:0] unformattedCodeNumberFirst], [[codes objectAtIndex:1] unformattedCodeNumberFirst]];
    }
    return codeString;
}

// separator can be newline, or string like " and " --> note must add spaces
+ (NSString *)printSedationCodes:(NSArray *)codes separator:(NSString *)separator {
    NSString *codeString = @"";
    if (codes == nil || [codes count] < 1) {
        return codeString;
    }
    if ([codes count] == 1) {
        codeString = [[codes objectAtIndex:0] unformattedCodeNumber];
    }
    else {
        codeString = [NSString stringWithFormat:@"%@%@%@", [[codes objectAtIndex:0] unformattedCodeNumber], separator, [[codes objectAtIndex:1] unformattedCodeNumber]];
    }
    return codeString;
}

+ (NSString *)sedationDetail:(NSArray *)codes sedationStatus:(SedationStatus)status {
    NSString *detail;
    // printSedationCodes returns empty string if codes == nil
    NSString *codeDetails = [self printSedationCodes:codes separator:@", "];
    switch (status) {
        case Unassigned:
            detail = UNASSIGNED_SEDATION_STRING;
            break;
        case None:
            detail = NO_SEDATION_STRING;
            break;
        case LessThan10Mins:
            detail = SHORT_SEDATION_TIME_STRING;
            break;
        case OtherMDCalculated:
            detail = [NSString stringWithFormat:OTHER_MD_CALCULATED_SEDATION_TIME_STRING, codeDetails];
            break;
        case AssignedSameMD:
            detail = codeDetails;
    }
    return detail;
}

- (NSString *)printSedationCodesWithSeparator:(NSString *)separator {
    return [EPSSedationCode printSedationCodes:self.sedationCodes separator:separator];
}

- (NSString *)sedationDetail:(SedationStatus)status {
    return [EPSSedationCode sedationDetail:self.sedationCodes sedationStatus:status];
}


@end
