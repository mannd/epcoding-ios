//
//  EPSSedationCode.h
//  EP Coding
//
//  Created by David Mann on 2/19/17.
//  Copyright © 2017 David Mann. All rights reserved.
//

#import "EPSCode.h"

FOUNDATION_EXPORT NSString *const SEDATION_CODE_NUMBER;
FOUNDATION_EXPORT NSString *const NO_SEDATION_STRING;
FOUNDATION_EXPORT NSString *const UNASSIGNED_SEDATION_STRING;
FOUNDATION_EXPORT NSString *const SHORT_SEDATION_TIME_STRING;
FOUNDATION_EXPORT NSString *const OTHER_MD_UNCALCULATED_SEDATION_TIME_STRING;
FOUNDATION_EXPORT NSString *const OTHER_MD_CALCULATED_SEDATION_TIME_STRING;

@interface EPSSedationCode : EPSCode

typedef NS_ENUM(NSInteger, SedationStatus) {
    Unassigned,
    None,
    LessThan10Mins,
    OtherMDUnCalculated,
    OtherMDCalculated,
    AssignedSameMD
};

@property SedationStatus sedationStatus;
@property (strong, nonatomic) NSMutableArray *sedationCodes;

+ (NSArray *)sedationCoding:(NSInteger)sedationTime sameMD:(BOOL)sameMD patientOver5:(BOOL)patientOver5;
+ (NSUInteger)codeMultiplier:(NSInteger)time;
+ (NSString *)printSedationCodes:(NSArray *)codes separator:(NSString *)separator;
+ (NSString *)printSedationCodesWithDescriptions:(NSArray *)codes;
+ (NSString *)sedationDetail:(NSArray *)codes sedationStatus:(SedationStatus)status;

- (id)initWithNumber:(NSString *)number description:(NSString *)description isAddOn:(BOOL)isAddOn;
- (id)init;

- (NSString *)unformattedCodeDescription;
- (NSString *)printSedationCodesWithSeparator:(NSString *)separator;
- (NSString *)sedationDetail:(SedationStatus)status;



@end
