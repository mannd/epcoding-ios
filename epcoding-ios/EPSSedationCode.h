//
//  EPSSedationCode.h
//  EP Coding
//
//  Created by David Mann on 2/19/17.
//  Copyright © 2017 David Mann. All rights reserved.
//

#import "EPSCode.h"

@interface EPSSedationCode : EPSCode

@property SedationStatus sedationStatus;
@property (strong, nonatomic) EPSCode *code1;
@property (strong, nonatomic) EPSCode *code2;

- (id)initWithNumber:(NSString *)number description:(NSString *)description isAddOn:(BOOL)isAddOn;
- (id)init;

- (NSString *)unformattedCodeDescription;

@end
