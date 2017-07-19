//
//  ICD10Codes.m
//  EP Coding
//
//  Created by David Mann on 7/19/17.
//  Copyright © 2017 David Mann. All rights reserved.
//

#import "ICD10Code.h"
#import "ICD10Codes.h"

#define ICD10CODE_FILENAME @"cardICD10codes2017"

@implementation ICD10Codes

+ (NSDictionary *)allCodes
{
    static NSMutableDictionary *dictionary;
    if (dictionary == nil) {
        dictionary = [[NSMutableDictionary alloc] init];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:ICD10CODE_FILENAME ofType:@"txt"];
        if (path == nil) {
            [dictionary setObject:[ICD10Code fileNotFoundICD10Code] forKey:[ICD10Code fileNotFoundICD10Code].number];
        }
        
        

    }
    return dictionary;
}

+ (NSArray *)allCodesArray
{
    NSDictionary *dictionary = [self allCodes];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[dictionary allValues]];
    return array;
}




@end
