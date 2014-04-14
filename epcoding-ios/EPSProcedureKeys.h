//
//  EPSProcedureKeys.h
//  EP Coding
//
//  Created by David Mann on 2/25/14.
//  Copyright (c) 2014 David Mann. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AFB_ABLATION_TITLE @"AFB Ablation"
#define SVT_ABLATION_TITLE @"SVT Ablation"
#define VT_ABLATION_TITLE @"VT Ablation"
#define AVN_ABLATION_TITLE @"AV Node Ablation"
#define EP_TESTING_TITLE @"EP Testing"
#define NEW_PPM_TITLE @"New PPM"
#define NEW_ICD_TITLE @"New ICD"
#define REPLACE_PPM_TITLE @"Replace PPM"
#define REPLACE_ICD_TITLE @"Replace ICD"
#define UPGRADE_SYSTEM_TITLE @"Upgrade/Revise/Extract"
#define SUBQ_ICD_TITLE @"SubQ ICD"
#define OTHER_PROCEDURE_TITLE @"Other Procedures"
#define ALL_EP_CODES_TITLE @"All EP Codes"
#define SEARCH_CODES_TITLE @"Search Codes"
#define DEVICE_WIZARD_TITLE @"Device Wizard"

// somewhat arbitrary string 
#define NO_CODE_KEY @"EPSNoCodeKEY1234"

// special code for all EP codes primary codes
#define ALL_EP_CODES_PRIMARY_CODES @"allEpCodesPrimaryCodes"

@interface EPSProcedureKeys : NSObject
+ (NSDictionary *)keyDictionary;

@end
