//
//  EPSCodeAnalyzer.h
//  EP Coding
//
//  Created by David Mann on 3/1/14.
//  Copyright (c) 2014 David Mann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EPSCodes.h"
#import "EPSSedationCode.h"

@interface EPSCodeAnalyzer : NSObject

@property (weak, nonatomic) NSArray *primaryCodes;
@property (weak, nonatomic) NSArray *secondaryCodes;
@property (weak, nonatomic) NSArray *sedationCodes;
@property (strong, nonatomic) NSMutableArray *allCodes;
@property BOOL ignoreNoSecondaryCodes;
@property SedationStatus sedationStatus;

- (id)initWithPrimaryCodes:(NSArray *)primaryCodes secondaryCodes:(NSArray *)secondaryCodes ignoreNoSecondaryCodes:(BOOL)ignoreNoSecondaryCodes sedationCodes:(NSArray *)sedationCodes sedationStatus:(SedationStatus)sedationStatus;

- (NSArray *)analysis;

- (NSArray *)allCodeNumbers;
- (NSArray *)codeNumbersFromCodes:(NSArray *)codes;
- (BOOL)allAddOnCodes;
+ (NSString *)codeNumbersToString:(NSArray *)codeNumbers;

- (BOOL)noMappingCodesForAblation;
- (NSArray *)codesWithBadCombosFromCodeSet:(NSSet *)codeNumberSet andBadCodeNumbers:(NSArray *)badCodeNumbers;
- (NSArray *)firstSpecialCodeNumberErrors;
- (NSArray *)duplicateCodeErrors;

@end
