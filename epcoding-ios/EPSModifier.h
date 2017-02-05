//
//  EPSModifier.h
//  EP Coding
//
//  Created by David Mann on 1/15/17.
//  Copyright © 2017 David Mann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EPSModifier : NSObject

@property (weak, nonatomic) NSString *number;
@property (weak, nonatomic) NSString *fullDescription;

- (id)initWithNumber:(NSString *)number andDescription:(NSString *)description;
- (NSComparisonResult)compareModifiers:(id)object;

@end
