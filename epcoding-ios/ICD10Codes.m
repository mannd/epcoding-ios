//
//  ICD10Codes.m
//  EP Coding
//
//  Created by David Mann on 7/19/17.
//  Copyright © 2017 David Mann. All rights reserved.
//

#import "ICD10Code.h"
#import "ICD10Codes.h"

#define ICD10CODE_FILENAME @"icd10cm_codes_2022"


@implementation ICD10Codes

+ (NSArray *)allCodes
{
    static NSMutableArray *array;
    if (array == nil) {
        array = [[NSMutableArray alloc] init];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:ICD10CODE_FILENAME ofType:@"txt"];
        if (path == nil) {
            [array addObject:[ICD10Code fileNotFoundICD10Code]];
            return [NSArray arrayWithArray:array];
        }
        // read everything from text
        NSString* fileContents = [NSString stringWithContentsOfFile:path
                                  encoding:NSUTF8StringEncoding error:nil];
        
        // turn /r/n into just /n
        // For efficiency, change line endings in text file manually to just \n, and skip below
        //fileContents = [fileContents stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        // then, separate by new line
        NSArray* allLinedStrings =
        [fileContents componentsSeparatedByCharactersInSet:
         [NSCharacterSet newlineCharacterSet]];
        
        for (int i = 0; i < allLinedStrings.count; i++) {
            // if there is a short line or file is terminated by \n, skip it
            if ([allLinedStrings[i] length] < 7) {
                continue;
            }
            ICD10Code *code = [[ICD10Code alloc] initWithString:allLinedStrings[i]];
            [array addObject:code];
        }
    }
    return [NSArray arrayWithArray:array];
}



@end
