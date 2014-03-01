//
//  EPSCodeError.h
//  EP Coding
//
//  Created by David Mann on 3/1/14.
//  Copyright (c) 2014 David Mann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EPSCode.h"

@interface EPSCodeError : NSObject

@property enum status warningLevel;
@property (weak, nonatomic) NSMutableArray *codes;
@property (weak, nonatomic) NSString *message;

- (id)initWithCodes:(NSMutableArray *)codes withWarningLevel:(enum status)level withMessage:(NSString *)message;

@end
