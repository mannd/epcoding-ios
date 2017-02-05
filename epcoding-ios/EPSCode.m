//
//  EPSCode.m
//  EP Coding
//
//  Created by David Mann on 2/21/14.
//  Copyright (c) 2014 David Mann. All rights reserved.
//

#import "EPSCode.h"

@implementation EPSCode


- (id)initWithNumber:(NSString *)number description:(NSString *)description isAddOn:(BOOL)isAddOn
{
    if (self = [super init]) {
        self.number = number;
        self.fullDescription = description;
        self.isAddOn = isAddOn;
        self.codeStatus = GOOD;
        // multiplier only shown if > 0
        self.multiplier = 0;
        self.modifiers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)markCodeStatus:(enum status)status
{
    // only go up on level or leave alone, never go down
    if (status > self.codeStatus) {
        self.codeStatus = status;
    }
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
    return self.descriptionShortened ? [self truncateString:self.fullDescription newLength:24] : self.fullDescription;
}

// below only used in unit tests
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
    return [[NSString alloc] initWithFormat:@"%@ (%@)", self.fullDescription,
            [self unformattedCodeNumber]];
}

- (NSString *)unformattedCodeNumberFirst
{
    return [[NSString alloc] initWithFormat:@"(%@) %@", [self unformattedCodeNumber], self.fullDescription];
}

- (NSString *)unformattedCodeNumber
{
    if (self.multiplier < 1) {
        return [[NSString alloc] initWithFormat:@"%@%@%@", self.isAddOn ? @"+" : @"", self.number, [self modiferString]];
    }
    else {
        return [[NSString alloc] initWithFormat:@"%@%@%@ x %lu", self.isAddOn ? @"+" : @"", self.number, [self modiferString], (unsigned long)self.multiplier];
    }
}

- (NSString *)unformattedCodeDescription
{
    return self.fullDescription;
}

- (NSComparisonResult)compareCodes:(id)object
{
    return [self.number compare:[object number]];
}

- (void)addModifier:(EPSModifier *)modifier {
    [self.modifiers addObject:modifier];
}

- (void)clearModifiers {
    [self.modifiers removeAllObjects];
}

- (NSString *)modiferString {
    if ([self.modifiers count] < 1) {
        return @"";
    }
    else {
        NSString *modifierString = @"";
        for (EPSModifier *modifier in self.modifiers) {
            modifierString = [modifierString stringByAppendingString:[NSString stringWithFormat:@"-%@", modifier.number]];
        }
        return modifierString;
    }
}
@end
