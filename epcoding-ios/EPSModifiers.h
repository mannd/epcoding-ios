//
//  EPSModifiers.h
//  EP Coding
//
//  Created by David Mann on 2/4/17.
//  Copyright © 2017 David Mann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EPSModifier.h"

@interface EPSModifiers : NSObject

+ (NSDictionary *)allModifiers;
+ (void)addModifier:(EPSModifier *)modifier toDictionary:(NSMutableDictionary *)dictionary;
+ (NSArray *)allModifiersSorted;
+ (void)clearSelectedAllModifiers;

@end
