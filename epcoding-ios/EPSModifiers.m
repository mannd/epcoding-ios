//
//  EPSModifiers.m
//  EP Coding
//
//  Created by David Mann on 2/4/17.
//  Copyright © 2017 David Mann. All rights reserved.
//

#import "EPSModifiers.h"

@implementation EPSModifiers

//+ (NSDictionary *)allCodes
//{
//    static NSMutableDictionary *dictionary;
//    if (dictionary == nil) {
//        dictionary = [[NSMutableDictionary alloc] init];
//        
//        // SubQ ICD
//        [self addCode:[[EPSCode alloc] initWithNumber:@"33270" description:@"New or replacement SubQ ICD system, includes testing" isAddOn:NO] toDictionary:dictionary];
//

+ (NSDictionary *)allModifiers
{
    static NSMutableDictionary *dictionary;
    if (dictionary == nil) {
        dictionary = [[NSMutableDictionary alloc] init];
        
        [self addModifier:[[EPSModifier alloc] initWithNumber:@"26" andDescription:@"Professional component"] toDictionary:dictionary];
        [self addModifier:[[EPSModifier alloc] initWithNumber:@"52" andDescription:@"Reduced services"] toDictionary:dictionary];
        [self addModifier:[[EPSModifier alloc] initWithNumber:@"59" andDescription:@"Distinct procedural service"] toDictionary:dictionary];
        [self addModifier:[[EPSModifier alloc] initWithNumber:@"76" andDescription:@"Repeat procedure by same MD"] toDictionary:dictionary];
        [self addModifier:[[EPSModifier alloc] initWithNumber:@"78" andDescription:@"Return to OR for related procedure during post-op period"] toDictionary:dictionary];
        [self addModifier:[[EPSModifier alloc] initWithNumber:@"Q0" andDescription:@"Investigative clinical service (e.g. ICD for primary prevention)"] toDictionary:dictionary];
    }
    return dictionary;
}

+ (NSArray *)allModifiersSorted
{
    NSDictionary *dictionary = [self allModifiers];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[dictionary allValues]];
    NSArray *sortedModifiers = [array sortedArrayUsingSelector:@selector(compareModifiers:)];
    return sortedModifiers;
}


+ (void)addModifier:(EPSModifier *)modifier toDictionary:(NSMutableDictionary *)dictionary
{
    [dictionary setObject:modifier forKey:modifier.number];
}

@end
