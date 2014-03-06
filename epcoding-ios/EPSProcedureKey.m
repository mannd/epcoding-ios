//
//  EPSProcedureKey.m
//  EP Coding
//
//  Created by David Mann on 2/25/14.
//  Copyright (c) 2014 David Mann. All rights reserved.
//

#import "EPSProcedureKey.h"

@implementation EPSProcedureKey

- (id)initWithPrimaryKey:(NSString *)primaryKey secondaryKey:(NSString *)secondaryKey disabledKey:(NSString *)disabledKey disablePrimaryCodes:(BOOL)disablePrimaryCodes ignoreNoSecondaryCodesSelected:(BOOL)ignoreNoSecondaryCodesSelected;
{
    if (self  = [super init]) {
        self.primaryCodesKey = primaryKey;
        self.secondaryCodesKey = secondaryKey;
        self.disabledCodesKey = disabledKey;
        self.disablePrimaryCodes = disablePrimaryCodes;
        self.ignoreNoSecondaryCodesSelected = ignoreNoSecondaryCodesSelected;
    }
    return self;
}

@end
