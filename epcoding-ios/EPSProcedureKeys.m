//
//  EPSProcedureKeys.m
//  EP Coding
//
//  Created by David Mann on 2/25/14.
//  Copyright (c) 2014 David Mann. All rights reserved.
//

#import "EPSProcedureKeys.h"
#import "EPSProcedureKey.h"

@implementation EPSProcedureKeys


+ (NSDictionary *)keyDictionary
{
    static NSMutableDictionary *dictionary;
    if (dictionary == nil) {
        dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setObject:[[EPSProcedureKey alloc] initWithPrimaryKey:@"afbAblationPrimaryCodes" secondaryKey:@"afbAblationSecondaryCodes" disabledKey:@"afbAblationDisabledCodes"] forKey:AFB_ABLATION_TITLE];
    }
    return dictionary;
}

@end
