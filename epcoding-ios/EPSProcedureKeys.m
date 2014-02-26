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
        [dictionary setObject:[[EPSProcedureKey alloc] initWithPrimaryKey:@"afbAblationPrimaryCodes" secondaryKey:@"ablationSecondaryCodes" disabledKey:@"afbAblationDisabledCodes" disablePrimaryCodes:YES ignoreNoSecondaryCodesSelected:NO] forKey:AFB_ABLATION_TITLE];
        [dictionary setObject:[[EPSProcedureKey alloc] initWithPrimaryKey:@"svtAblationPrimaryCodes" secondaryKey:@"ablationSecondaryCodes" disabledKey:@"svtAblationDisabledCodes" disablePrimaryCodes:YES ignoreNoSecondaryCodesSelected:NO] forKey:SVT_ABLATION_TITLE];
        [dictionary setObject:[[EPSProcedureKey alloc] initWithPrimaryKey:@"vtAblationPrimaryCodes" secondaryKey:@"ablationSecondaryCodes" disabledKey:@"vtAblationDisabledCodes" disablePrimaryCodes:YES ignoreNoSecondaryCodesSelected:NO] forKey:VT_ABLATION_TITLE];
        [dictionary setObject:[[EPSProcedureKey alloc] initWithPrimaryKey:@"avnAblationPrimaryCodes" secondaryKey:@"avnAblationSecondaryCodes" disabledKey:NO_CODE_KEY disablePrimaryCodes:YES ignoreNoSecondaryCodesSelected:NO] forKey:AVN_ABLATION_TITLE];
        [dictionary setObject:[[EPSProcedureKey alloc] initWithPrimaryKey:@"epTestingPrimaryCodes" secondaryKey:@"ablationSecondaryCodes" disabledKey:@"epTestingDisabledCodes" disablePrimaryCodes:NO ignoreNoSecondaryCodesSelected:YES] forKey:EP_TESTING_TITLE];
        [dictionary setObject:[[EPSProcedureKey alloc] initWithPrimaryKey:@"newPpmPrimaryCodes" secondaryKey:@"newPpmSecondaryCodes" disabledKey:NO_CODE_KEY disablePrimaryCodes:NO ignoreNoSecondaryCodesSelected:YES] forKey:NEW_PPM_TITLE];
        [dictionary setObject:[[EPSProcedureKey alloc] initWithPrimaryKey:@"newIcdPrimaryCodes" secondaryKey:@"newIcdSecondaryCodes" disabledKey:NO_CODE_KEY disablePrimaryCodes:NO ignoreNoSecondaryCodesSelected:NO] forKey:NEW_ICD_TITLE];
        [dictionary setObject:[[EPSProcedureKey alloc] initWithPrimaryKey:@"replacePpmPrimaryCodes" secondaryKey:@"replacePpmSecondaryCodes" disabledKey:NO_CODE_KEY disablePrimaryCodes:NO ignoreNoSecondaryCodesSelected:YES] forKey:REPLACE_PPM_TITLE];
        [dictionary setObject:[[EPSProcedureKey alloc] initWithPrimaryKey:@"replaceIcdPrimaryCodes" secondaryKey:@"replaceIcdSecondaryCodes" disabledKey:NO_CODE_KEY disablePrimaryCodes:NO ignoreNoSecondaryCodesSelected:NO] forKey:REPLACE_ICD_TITLE];
        [dictionary setObject:[[EPSProcedureKey alloc] initWithPrimaryKey:@"upgradeSystemPrimaryCodes" secondaryKey:@"upgradeSystemSecondaryCodes" disabledKey:NO_CODE_KEY disablePrimaryCodes:NO ignoreNoSecondaryCodesSelected:YES] forKey:UPGRADE_SYSTEM_TITLE];
        [dictionary setObject:[[EPSProcedureKey alloc] initWithPrimaryKey:@"otherProcedurePrimaryCodes" secondaryKey:NO_CODE_KEY disabledKey:NO_CODE_KEY disablePrimaryCodes:NO ignoreNoSecondaryCodesSelected:YES] forKey:OTHER_PROCEDURE_TITLE];
          [dictionary setObject:[[EPSProcedureKey alloc] initWithPrimaryKey:@"subQIcdPrimaryCodes" secondaryKey:NO_CODE_KEY disabledKey:NO_CODE_KEY disablePrimaryCodes:NO ignoreNoSecondaryCodesSelected:NO] forKey:SUBQ_ICD_TITLE];
        [dictionary setObject:[[EPSProcedureKey alloc] initWithPrimaryKey:@"allEpCodesPrimaryCodes" secondaryKey:NO_CODE_KEY disabledKey:NO_CODE_KEY disablePrimaryCodes:NO ignoreNoSecondaryCodesSelected:NO] forKey:ALL_EP_CODES_TITLE];
    }
    
    return dictionary;
}

@end
