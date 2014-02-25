//
//  EPSProcedureKey.h
//  EP Coding
//
//  Created by David Mann on 2/25/14.
//  Copyright (c) 2014 David Mann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EPSProcedureKey : NSObject

@property (strong, nonatomic) NSString *primaryCodesKey;
@property (strong, nonatomic) NSString *secondaryCodesKey;
@property (strong, nonatomic) NSString *disabledCodesKey;
@property BOOL disablePrimaryCodes;
@property BOOL ignoreNoSecondaryCodesSelected;

- (id)initWithPrimaryKey:(NSString *)primaryKey secondaryKey:(NSString *)secondaryKey disabledKey:(NSString *)disabledKey disablePrimaryCodes:(BOOL)disablePrimaryCodes ignoreNoSecondaryCodesSelected:(BOOL)ignoreNoSecondaryCodesSelected;

@end
