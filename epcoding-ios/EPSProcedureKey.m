//
//  EPSProcedureKey.m
//  EP Coding
//
//  Created by David Mann on 2/25/14.
//  Copyright (c) 2014 David Mann. All rights reserved.
//

#import "EPSProcedureKey.h"

@implementation EPSProcedureKey

- (id)initWithPrimaryKey:(NSString *)primaryKey secondarykey:(NSString *)secondaryKey disabledKey:(NSString *)disabledKey
{
    if ([super init]) {
        self.primaryCodesKey = primaryKey;
        self.secondaryCodesKey = secondaryKey;
        self.disabledCodesKey = disabledKey;
    }
    return self;
}

@end
