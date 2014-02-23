//
//  EPSCodes.h
//  EP Coding
//
//  Created by David Mann on 2/22/14.
//  Copyright (c) 2014 David Mann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EPSCode.h"

@interface EPSCodes : NSObject

+ (NSMutableDictionary *)allCodes;
+ (void)addCode:(EPSCode *)code toDictionary:(NSMutableDictionary *)dictionary;
+ (EPSCode *)getCodeForNumber:(NSString *)codeNumber;
+ (NSMutableDictionary *)getCodesForCodeNumbers:(NSArray *)codeNumbers;


@end
