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

+ (NSDictionary *)allCodes;
+ (void)addCode:(EPSCode *)code toDictionary:(NSMutableDictionary *)dictionary;
+ (EPSCode *)getCodeForNumber:(NSString *)codeNumber;
+ (NSArray *)getCodesForCodeNumbers:(NSArray *)codeNumbers;
+ (NSArray *)allCodesSorted;

+ (NSString *)codeNumberFromCodeString:(NSString *)codeString leavePlus:(BOOL)leavePlus;

+ (NSDictionary *)codeDictionary;

+ (NSUInteger)codeMultiplier:(NSInteger)time;
+ (void)clearMultipliers:(NSArray *)array;
+ (void)clearModifiers:(NSArray *)array;
+ (NSDictionary *)defaultModifiers;
+ (void)clearMultipliersAndModifiers:(NSArray *)array;
+ (void)loadDefaultModifiers:(NSArray *)codes;
+ (void)loadSavedModifiers:(NSArray *)codes;+ (void)resetSavedModifiers:(NSArray *)codes;
+ (NSArray *)sedationCoding:(NSInteger)sedationTime sameMD:(BOOL)sameMD patientOver5:(BOOL)patientOver5;
+ (NSString *)printSedationCodes:(NSArray *)codes separator:(NSString *)separator;

@end
