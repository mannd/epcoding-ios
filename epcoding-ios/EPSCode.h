//
//  EPSCode.h
//  EP Coding
//
//  Created by David Mann on 2/21/14.
//  Copyright (c) 2014 David Mann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EPSCode : NSObject

@property (weak, nonatomic) NSString *number;
@property (weak, nonatomic) NSString *description;
@property BOOL isAddOn;
@property BOOL plusShown;
@property BOOL descriptionShortened;
@property BOOL descriptonShown;
@property BOOL selected;
@property enum status codeStatus;

enum status {GOOD, WARNING, ERROR};

- (id)initWithNumber:(NSString *)number description:(NSString *)description isAddOn:(BOOL)isAddOn;

- (void)markCodeStatus:(enum status)status;

- (NSString *)formattedCode;

- (NSString *)unformattedCodeDescriptionFirst;
- (NSString *)unformattedCodeNumberFirst;
- (NSString *)unformattedCodeNumber;
- (NSString *)unformattedCodeDescription;

@end
