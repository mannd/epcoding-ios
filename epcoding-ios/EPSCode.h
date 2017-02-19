//
//  EPSCode.h
//  EP Coding
//
//  Created by David Mann on 2/21/14.
//  Copyright (c) 2014 David Mann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EPSModifier.h"

FOUNDATION_EXPORT NSString *const NO_SEDATION_STRING;
FOUNDATION_EXPORT NSString *const UNASSIGNED_SEDATION_STRING;
FOUNDATION_EXPORT NSString *const SHORT_SEDATION_TIME_STRING;
FOUNDATION_EXPORT NSString *const OTHER_MD_UNCALCULATED_SEDATION_TIME_STRING;
FOUNDATION_EXPORT NSString *const OTHER_MD_CALCULATED_SEDATION_TIME_STRING;

@interface EPSCode : NSObject

typedef NS_ENUM(NSInteger, SedationStatus) {
    Unassigned,
    None,
    LessThan10Mins,
    OtherMDUnCalculated,
    OtherMDCalculated,
    AssignedSameMD
};


@property (strong, nonatomic) NSString *number;
@property (strong, nonatomic) NSString *fullDescription;
@property BOOL isAddOn;
@property BOOL plusShown;
@property BOOL descriptionShortened;
@property BOOL descriptonShown;
@property BOOL selected;
@property enum status codeStatus;
@property NSInteger multiplier;
@property (strong, nonatomic) NSMutableArray *modifiers;

enum status {GOOD, WARNING, ERROR};

- (id)initWithNumber:(NSString *)number description:(NSString *)description isAddOn:(BOOL)isAddOn;

- (void)addModifier:(EPSModifier *)modifier;
- (void)addModifiers:(NSArray *)modifiers;
- (void)clearModifiers;

- (void)markCodeStatus:(enum status)status;

- (NSString *)formattedCode;

- (NSString *)unformattedCodeDescriptionFirst;
- (NSString *)unformattedCodeNumberFirst;
- (NSString *)unformattedCodeNumber;
- (NSString *)unformattedCodeDescription;
- (NSComparisonResult)compareCodes:(id)object;
- (NSString *)modifierString;

@end
