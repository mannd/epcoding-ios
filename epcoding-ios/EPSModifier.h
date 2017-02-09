//
//  EPSModifier.h
//  EP Coding
//
//  Created by David Mann on 1/15/17.
//  Copyright © 2017 David Mann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EPSModifier : NSObject

@property (strong, nonatomic) NSString *number;
@property (strong, nonatomic) NSString *fullDescription;
@property BOOL selected;

- (id)initWithNumber:(NSString *)number andDescription:(NSString *)description;
- (NSComparisonResult)compareModifiers:(id)object;

@end
