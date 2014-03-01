//
//  EPSCodeAnalyzer.h
//  EP Coding
//
//  Created by David Mann on 3/1/14.
//  Copyright (c) 2014 David Mann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EPSCodeAnalyzer : NSObject

@property (weak, nonatomic) NSArray *primaryCodes;
@property (weak, nonatomic) NSArray *secondaryCodes;
@property BOOL ignoreNoSecondaryCodes;

- (id)initWithPrimaryCodes:(NSArray *)primaryCodes secondaryCodes:(NSArray *)secondaryCodes ignoreNoSecondaryCodes:(BOOL)ignoreNoSecondaryCodes;

- (NSArray *)analysis;

- (NSArray *)allCodes;
- (NSArray *)allCodeNumbers;

@end
