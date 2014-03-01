//
//  EPSCode.m
//  EP Coding
//
//  Created by David Mann on 2/21/14.
//  Copyright (c) 2014 David Mann. All rights reserved.
//

#import "EPSCode.h"

@implementation EPSCode


-(id)initWithNumber:(NSString *)number description:(NSString *)description isAddOn:(BOOL)isAddOn
{
    if ([super init]) {
        self.number = number;
        self.description = description;
        self.isAddOn = isAddOn;
        self.codeStatus = GOOD;
    }
    return self;
}

// This function returns the formatted code used in the summary box, affected by
// the various properties
- (NSString *)formattedCode
{
    NSString *s = [[NSString alloc] initWithFormat:@"(%@)%@", [self formattedCodeNumber], self.descriptonShown ? [[NSString alloc] initWithFormat:@" %@", [self formattedDescription]] : @""];
    return s;
}

- (NSString *)formattedDescription
{
    return self.descriptionShortened ? [self truncateString:self.description newLength:24] : self.description;
}

- (NSString *)formattedCodeNumber
{
    return [[NSString alloc] initWithFormat:@"%@", self.plusShown ? [self unformattedCodeNumber] : self.number];
}

- (NSString *)truncateString:(NSString *)s newLength:(int)newLength
{
   	if (newLength >= [s length])
        return s;
    NSString *substring = [s substringToIndex:newLength - 3 ];
    return [[NSString alloc] initWithFormat:@"%@...", substring];
}


// These functions ignore formatting properties (e.g. plusShown, descriptionShortened
// and are used for the checkbox checklists, not for summary screen
- (NSString *)unformattedCodeDescriptionFirst
{
    return [[NSString alloc] initWithFormat:@"%@ (%@)", self.description,
            [self unformattedCodeNumber]];
}

- (NSString *)unformattedCodeNumberFirst
{
    return [[NSString alloc] initWithFormat:@"(%@) %@", [self unformattedCodeNumber], self.description];
}

- (NSString *)unformattedCodeNumber
{
    return [[NSString alloc] initWithFormat:@"%@%@", self.isAddOn ? @"+" : @"", self.number];
}

- (NSString *)unformattedCodeDescription
{
    return self.description;
}



@end
