//
//  EPSProcedureKeys.m
//  EP Coding
//
//  Created by David Mann on 2/25/14.
//  Copyright (c) 2014 David Mann. All rights reserved.
//

#import "EPSProcedureKeys.h"
#import "EPSProcedureKey.h"

@implementation EPSProcedureKeys


+ (NSDictionary *)keyDictionary
{
    static NSMutableDictionary *dictionary;
    if (dictionary == nil) {
        dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setObject:[[EPSProcedureKey alloc] initWithPrimaryKey:@"afbAblationPrimaryCodes" secondaryKey:@"afbAblationSecondaryCodes" disabledKey:@"afbAblationDisabledCodes" disablePrimaryCodes:YES ignoreNoSecondaryCodesSelected:NO] forKey:AFB_ABLATION_TITLE];
        [dictionary setObject:[[EPSProcedureKey alloc] initWithPrimaryKey:@"svtAblationPrimaryCodes" secondaryKey:@"svtAblationSecondaryCodes" disabledKey:@"svtAblationDisabledCodes" disablePrimaryCodes:YES ignoreNoSecondaryCodesSelected:NO] forKey:SVT_ABLATION_TITLE];
        [dictionary setObject:[[EPSProcedureKey alloc] initWithPrimaryKey:@"vtAblationPrimaryCodes" secondaryKey:@"vtAblationSecondaryCodes" disabledKey:@"vtAblationDisabledCodes" disablePrimaryCodes:YES ignoreNoSecondaryCodesSelected:NO] forKey:VT_ABLATION_TITLE];
        [dictionary setObject:[[EPSProcedureKey alloc] initWithPrimaryKey:@"avnAblationPrimaryCodes" secondaryKey:@"avnAblationSecondaryCodes" disabledKey:NO_CODE_KEY disablePrimaryCodes:YES ignoreNoSecondaryCodesSelected:NO] forKey:AVN_ABLATION_TITLE];
        [dictionary setObject:[[EPSProcedureKey alloc] initWithPrimaryKey:@"EpTestingPrimaryCodes" secondaryKey:@"EpTestingSecondaryCodes" disabledKey:@"EpTestingDisabledCodes" disablePrimaryCodes:NO ignoreNoSecondaryCodesSelected:YES] forKey:EP_TESTING_TITLE];
        [dictionary setObject:[[EPSProcedureKey alloc] initWithPrimaryKey:@"NewPpmPrimaryCodes" secondaryKey:@"NewPpmSecondaryCodes" disabledKey:NO_CODE_KEY disablePrimaryCodes:NO ignoreNoSecondaryCodesSelected:YES] forKey:AFB_ABLATION_TITLE];
//        [dictionary setObject:[[EPSProcedureKey alloc] initWithPrimaryKey:@"afbAblationPrimaryCodes" secondaryKey:@"afbAblationSecondaryCodes" disabledKey:@"afbAblationDisabledCodes"] forKey:AFB_ABLATION_TITLE];
//        [dictionary setObject:[[EPSProcedureKey alloc] initWithPrimaryKey:@"afbAblationPrimaryCodes" secondaryKey:@"afbAblationSecondaryCodes" disabledKey:@"afbAblationDisabledCodes"] forKey:AFB_ABLATION_TITLE];
//        [dictionary setObject:[[EPSProcedureKey alloc] initWithPrimaryKey:@"afbAblationPrimaryCodes" secondaryKey:@"afbAblationSecondaryCodes" disabledKey:@"afbAblationDisabledCodes"] forKey:AFB_ABLATION_TITLE];
//        [dictionary setObject:[[EPSProcedureKey alloc] initWithPrimaryKey:@"afbAblationPrimaryCodes" secondaryKey:@"afbAblationSecondaryCodes" disabledKey:@"afbAblationDisabledCodes"] forKey:AFB_ABLATION_TITLE];
//        [dictionary setObject:[[EPSProcedureKey alloc] initWithPrimaryKey:@"afbAblationPrimaryCodes" secondaryKey:@"afbAblationSecondaryCodes" disabledKey:@"afbAblationDisabledCodes"] forKey:AFB_ABLATION_TITLE];
//        [dictionary setObject:[[EPSProcedureKey alloc] initWithPrimaryKey:@"afbAblationPrimaryCodes" secondaryKey:@"afbAblationSecondaryCodes" disabledKey:@"afbAblationDisabledCodes"] forKey:AFB_ABLATION_TITLE];
//        [dictionary setObject:[[EPSProcedureKey alloc] initWithPrimaryKey:@"afbAblationPrimaryCodes" secondaryKey:@"afbAblationSecondaryCodes" disabledKey:@"afbAblationDisabledCodes"] forKey:AFB_ABLATION_TITLE];


    }
    
    return dictionary;
}

@end
