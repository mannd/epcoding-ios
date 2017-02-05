//
//  EPSModifier.m
//  EP Coding
//
//  Created by David Mann on 1/15/17.
//  Copyright © 2017 David Mann. All rights reserved.
//

#import "EPSModifier.h"

@implementation EPSModifier


- (id)initWithNumber:(NSString *)number andDescription:(NSString *)description {
    if (self = [super init]) {
        self.number = number;
        self.fullDescription = description;
    }
    return self;
}

- (NSComparisonResult)compareModifiers:(id)object
{
    return [self.number compare:[object number]];
}


@end
