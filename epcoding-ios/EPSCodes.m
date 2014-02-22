//
//  EPSCodes.m
//  EP Coding
//
//  Created by David Mann on 2/22/14.
//  Copyright (c) 2014 David Mann. All rights reserved.
//

#import "EPSCodes.h"

@implementation EPSCodes

static NSMutableDictionary *codeMap;

+ (NSDictionary *)createMap
{
    NSMutableDictionary * dictionary;
    
    return dictionary;
}

+ (void)addCode:(EPSCode *)code toDictionary:(NSMutableDictionary *)dictionary
{
    [dictionary setObject:code forKey:code.number];
}


@end
