//
//  ICD10Code.h
//  EP Coding
//
//  Created by David Mann on 7/19/17.
//  Copyright © 2017 David Mann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICD10Code : NSObject

@property (strong, nonatomic) NSString *number;
@property (strong, nonatomic) NSString *fullDescription;

+ (NSString *)processRawNumber:(NSString *)rawCodeNumber;
+ (ICD10Code *)fileNotFoundICD10Code;

- (id)initWithNumber:(NSString *)number description:(NSString *)description;
- (id)initWithString:(NSString *)string;


@end
