//
//  EPSCodeError.m
//  EP Coding
//
//  Created by David Mann on 3/1/14.
//  Copyright (c) 2014 David Mann. All rights reserved.
//

#import "EPSCodeError.h"

@implementation EPSCodeError

- (id)initWithCodes:(NSMutableArray *)codes withWarningLevel:(enum status)level withMessage:(NSString *)message
{
    if ([super init]) {
        self.codes = codes;
        self.warningLevel = level;
        self.message = message;
    }
    return self;
}



@end
