//
//  EPSModifiers.m
//  EP Coding
//
//  Created by David Mann on 2/4/17.
//  Copyright © 2017 David Mann. All rights reserved.
//

#import "EPSModifiers.h"

@implementation EPSModifiers

+ (NSDictionary *)allModifiers
{
    static NSMutableDictionary *dictionary;
    if (dictionary == nil) {
        dictionary = [[NSMutableDictionary alloc] init];
        
        [self addModifier:[[EPSModifier alloc] initWithNumber:@"26" andDescription:@"Professional component"] toDictionary:dictionary];
        [self addModifier:[[EPSModifier alloc] initWithNumber:@"51" andDescription:@"Multiple procedures (NB: many EP codes are modifier 51 exempt)"] toDictionary:dictionary];
        [self addModifier:[[EPSModifier alloc] initWithNumber:@"52" andDescription:@"Reduced services"] toDictionary:dictionary];
        [self addModifier:[[EPSModifier alloc] initWithNumber:@"53" andDescription:@"Discontinued procedure due to patient risk"] toDictionary:dictionary];
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

+ (NSSet *)allModifiersSet
{
    NSSet *set = [NSSet setWithArray:[EPSModifiers allModifiersSorted]];
    return set;
}


+ (void)addModifier:(EPSModifier *)modifier toDictionary:(NSMutableDictionary *)dictionary
{
    [dictionary setObject:modifier forKey:modifier.number];
}

+ (void)clearSelectedAllModifiers
{
    NSArray *array = [EPSModifiers allModifiersSorted];
    for (EPSModifier *modifier in array) {
        modifier.selected = NO;
    }
}

+ (EPSModifier *)getModifierForNumber:(NSString *)modifierNumber
{
    return [[EPSModifiers allModifiers] objectForKey:modifierNumber];
}



@end
