//
//  EPSCodes.m
//  EP Coding
//
//  Created by David Mann on 2/22/14.
//  Copyright (c) 2014 David Mann. All rights reserved.
//

#import "EPSCodes.h"

@implementation EPSCodes

+ (NSMutableDictionary *)createMap
{
    static NSMutableDictionary *dictionary;
    if (dictionary == nil) {
        dictionary = [[NSMutableDictionary alloc] init];
        [self addCode:[[EPSCode alloc] initWithNumber:@"0319T" description:@"Implantation of SubQ ICD system (generator & electrode)" isAddOn:NO] toDictionary:dictionary];
    }
    return dictionary;
}

+ (void)addCode:(EPSCode *)code toDictionary:(NSMutableDictionary *)dictionary
{
    [dictionary setObject:code forKey:code.number];
}


@end
