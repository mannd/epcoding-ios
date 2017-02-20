//
//  EPSCodes.m
//  EP Coding
//
//  Created by David Mann on 2/22/14.
//  Copyright (c) 2014 David Mann. All rights reserved.
//

#import "EPSCodes.h"
#import "EPSModifiers.h"


@implementation EPSCodes


+ (NSDictionary *)allCodes
{
    static NSMutableDictionary *dictionary;
    if (dictionary == nil) {
        dictionary = [[NSMutableDictionary alloc] init];
        
        // hopefully rarely needed!
        [self addCode:[[EPSCode alloc] initWithNumber:@"33010" description:@"Pericardiocentesis" isAddOn:NO] toDictionary:dictionary];
        
        // SubQ ICD
        [self addCode:[[EPSCode alloc] initWithNumber:@"33270" description:@"New or replacement SubQ ICD system, includes testing" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"33271" description:@"Insertion of SubQ defibrillator electrode only" isAddOn:NO] toDictionary:dictionary];
		[self addCode:[[EPSCode alloc] initWithNumber:@"33272" description:@"Removal of SubQ ICD electrode" isAddOn:NO] toDictionary:dictionary];
		[self addCode:[[EPSCode alloc] initWithNumber:@"33273" description:@"Repositioning of SubQ ICD electrode" isAddOn:NO] toDictionary:dictionary];

        // other PPM
        [self addCode:[[EPSCode alloc] initWithNumber:@"33206" description:@"New or replacement PPM with new A lead" isAddOn:NO] toDictionary:dictionary];
		[self addCode:[[EPSCode alloc] initWithNumber:@"33207" description:@"New or replacement PPM with new V lead" isAddOn:NO] toDictionary:dictionary];
		[self addCode:[[EPSCode alloc] initWithNumber:@"33208" description:@"New or replacement PPM with new A and V leads" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"33210" description:@"Insert temporary transvenous pacing electrode" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"33211" description:@"Insert temporary transvenous A and V pacing electrodes" isAddOn:NO] toDictionary:dictionary];
        
        // Leadless PPM
        [self addCode:[[EPSCode alloc] initWithNumber:@"0387T" description:@"New or replacement leadless PPM" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"0388T" description:@"Transcatheter removal of leadless PPM" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"0389T" description:@"Programming evaluation/testing of leadless PPM" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"0390T" description:@"Peri-procedural device evaluation/testing of leadless PPM" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"0391T" description:@"Interrogation of leadless PPM" isAddOn:NO] toDictionary:dictionary];
        
		// PPM Generators
		[self addCode:[[EPSCode alloc] initWithNumber:@"33212" description:@"Implant single chamber PPM generator, existing lead" isAddOn:NO] toDictionary:dictionary];
		[self addCode:[[EPSCode alloc] initWithNumber:@"33213" description:@"Implant dual chamber PPM generator, existing leads" isAddOn:NO] toDictionary:dictionary];
		[self addCode:[[EPSCode alloc] initWithNumber:@"33214" description:@"Upgrade single chamber to dual chamber PPM" isAddOn:NO] toDictionary:dictionary];
        
		// Leads
		[self addCode:[[EPSCode alloc] initWithNumber:@"33215" description:@"Repositioning of PPM or ICD electrode" isAddOn:NO] toDictionary:dictionary];
		[self addCode:[[EPSCode alloc] initWithNumber:@"33216" description:@"Implant single lead (A or V, PPM or ICD) only" isAddOn:NO] toDictionary:dictionary];
		[self addCode:[[EPSCode alloc] initWithNumber:@"33217" description:@"Implant dual leads (PPM or ICD) only" isAddOn:NO] toDictionary:dictionary];
		[self addCode:[[EPSCode alloc] initWithNumber:@"33218" description:@"Repair of one (PPM or ICD) electrode" isAddOn:NO] toDictionary:dictionary];
		[self addCode:[[EPSCode alloc] initWithNumber:@"33220" description:@"Repair of two (PPM or ICD) electrodes" isAddOn:NO] toDictionary:dictionary];
        
        
        // Pocket revisions
        [self addCode:[[EPSCode alloc] initWithNumber:@"33222" description:@"PPM pocket revision" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"33223" description:@"ICD pocket revision" isAddOn:NO] toDictionary:dictionary];
        
        [self addCode:[[EPSCode alloc] initWithNumber:@"33221" description:@"Implant CRT PPM generator, existing leads" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"33224" description:@"Addition of LV lead to preexisting ICD/PPM system" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"33225" description:@"Implant LV lead at time of ICD/PPM insertion" isAddOn:YES] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"33226" description:@"Repositioning of previously implanted LV lead" isAddOn:NO] toDictionary:dictionary];
        
        // Replacement/removal/extraction
        [self addCode:[[EPSCode alloc] initWithNumber:@"33227" description:@"Single chamber PPM generator replacement" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"33228" description:@"Dual chamber PPM generator replacement" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"33229" description:@"CRT PPM generator replacement" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"33230" description:@"Implant dual chamber ICD generator, existing leads" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"33231" description:@"Implant CRT ICD generator, existing leads" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"33233" description:@"Removal of PPM generator without replacement" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"33234" description:@"Removal electrode only single lead PPM system" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"33235" description:@"Removal electrodes only dual lead PPM system" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"33240" description:@"Implant single chamber ICD generator, existing lead" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"33241" description:@"Removal of ICD generator without replacement" isAddOn:NO] toDictionary:dictionary];
        // 33243 is removal of ICD lead by thoracotomy
        [self addCode:[[EPSCode alloc] initWithNumber:@"33244" description:@"Removal one or more electrodes, ICD system" isAddOn:NO] toDictionary:dictionary];
        
        // New ICD/CRT
        [self addCode:[[EPSCode alloc] initWithNumber:@"33249" description:@"New ICD, single or dual, with leads" isAddOn:NO] toDictionary:dictionary];
        
        // Replacement ICD/CRT
        [self addCode:[[EPSCode alloc] initWithNumber:@"33262" description:@"Single lead ICD generator replacement" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"33263" description:@"Dual lead ICD generator replacement" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"33264" description:@"CRT ICD generator replacement" isAddOn:NO] toDictionary:dictionary];
        
        // ILR
        [self addCode:[[EPSCode alloc] initWithNumber:@"33282" description:@"Insertion of loop recorder" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"33284" description:@"Removal of loop recorder" isAddOn:NO] toDictionary:dictionary];
        
        [self addCode:[[EPSCode alloc] initWithNumber:@"33999" description:@"Unlisted surgical procedure, e.g. SubQ array lead" isAddOn:NO] toDictionary:dictionary];
        
        // Misc
        [self addCode:[[EPSCode alloc] initWithNumber:@"35476" description:@"Venous angioplasty" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"36620" description:@"Arterial line placement" isAddOn:NO] toDictionary:dictionary];
        
        // note fluoroscopy included in device codes, but this code
        // used e.g to evaluate a lead such as a Riata
        [self addCode:[[EPSCode alloc] initWithNumber:@"76000" description:@"Fluoroscopic lead evaluation" isAddOn:NO] toDictionary:dictionary];
        
        // TEE - but only by different MD than performing procedure
        
        [self addCode:[[EPSCode alloc] initWithNumber:@"93355" description:@"TEE for guidance of transcatheter intervention, performed by different MD than MD performing intervention." isAddOn:NO] toDictionary:dictionary];
        // Ablation and EP testing codes
        
        // EP Testing and Mapping ///////////////////////
        [self addCode:[[EPSCode alloc] initWithNumber:@"93600" description:@"His bundle recording only" isAddOn:NO] toDictionary:dictionary];
        
        [self addCode:[[EPSCode alloc] initWithNumber:@"93609" description:@"2D mapping" isAddOn:YES] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"93613" description:@"3D mapping" isAddOn:YES] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"93619" description:@"EP testing without attempted arrhythmia induction" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"93620" description:@"EP testing with attempted arrhythmia induction" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"93621" description:@"LA pacing & recording" isAddOn:YES] toDictionary:dictionary];
        
        
        [self addCode:[[EPSCode alloc] initWithNumber:@"93622" description:@"LV pacing & recording" isAddOn:YES] toDictionary:dictionary];
        
        // TODO: This is wiped out by clear modifiers when each codeTable loads.  Where to add these modifiers?
//        EPSCode *code93622 = [self getCodeForNumber:@"93622"];
//        [code93622 addModifier:[EPSModifiers getModifierForNumber:@"26"]];
        
        [self addCode:[[EPSCode alloc] initWithNumber:@"93623" description:@"Induce post IV drug" isAddOn:YES] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"93624" description:@"Follow-up EP testing" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"93631" description:@"Intra-op mapping" isAddOn:NO] toDictionary:dictionary];
        
        // Ablation
        [self addCode:[[EPSCode alloc] initWithNumber:@"93650" description:@"AV node ablation" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"93653" description:@"SVT ablation" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"93654" description:@"VT ablation" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"93655" description:@"Additional SVT ablation" isAddOn:YES] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"93656" description:@"AFB ablation" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"93657" description:@"Additional AFB ablation" isAddOn:YES] toDictionary:dictionary];
        
        // Ancillary to EP Testing/Ablation, Other EP Procedures
        [self addCode:[[EPSCode alloc] initWithNumber:@"92960" description:@"Cardioversion (external)" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"92961" description:@"Cardioversion (internal)" isAddOn:NO] toDictionary:dictionary];
        // note, not clear if 92961 can be used with ICD cardioversion
        
        // skipped code 93640 used to test leads externally, not through device
        [self addCode:[[EPSCode alloc] initWithNumber:@"93641" description:@"DFT testing using ICD at time of ICD implant/replacement" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"93642" description:@"DFT testing using ICD not at time of implant/replacement" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"93462" description:@"Transseptal cath" isAddOn:YES] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"93660" description:@"Tilt table test" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"93662" description:@"Intracardiac echo" isAddOn:YES] toDictionary:dictionary];
        
        [self addCode:[[EPSCode alloc] initWithNumber:@"93724" description:@"Noninvasive programmed stimulation" isAddOn:NO] toDictionary:dictionary];

        
        // Unlisted procedure
        [self addCode:[[EPSCode alloc] initWithNumber:@"93799" description:@"Unlisted procedure" isAddOn:NO] toDictionary:dictionary];
        
        // New sedation codes, 2017
        [self addCode:[[EPSCode alloc] initWithNumber:@"99151" description:@"Mod sedation, same MD, initial 15 min, pt < 5 y/o" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"99152" description:@"Mod sedation, same MD, initial 15 min, pt ≥ 5 y/o" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"99153" description:@"Mod sedation, same MD, each additional 15 min" isAddOn:YES] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"99155" description:@"Mod sedation, different MD, initial 15 min, pt < 5 y/o" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"99156" description:@"Mod sedation, different MD, initial 15 min, pt ≥ 5 y/o" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"99157" description:@"Mod sedation, different MD, each additional 15 min" isAddOn:YES] toDictionary:dictionary];
        

    }
    return dictionary;
}

+ (void)addCode:(EPSCode *)code toDictionary:(NSMutableDictionary *)dictionary
{
    [dictionary setObject:code forKey:code.number];
}

+ (EPSCode *)getCodeForNumber:(NSString *)codeNumber
{
    return [[EPSCodes allCodes] objectForKey:codeNumber];
}

+ (NSArray *)getCodesForCodeNumbers:(NSArray *)codeNumbers
{
    if (codeNumbers == nil) {
        return nil;
    }
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (id codeNumber in codeNumbers)  {
        EPSCode *code = [EPSCodes getCodeForNumber:codeNumber];
        [array addObject:code];
    }
    return array;
}


// all the codes sets (e.g. afbAblationPrimaryCodes) are contained in this dictionary
// Format of keys: e.g. afbAblationPrimaryCodes, deviceSecondaryCodes, etc.
+ (NSDictionary *)codeDictionary
{
    static NSMutableDictionary *dictionary;
    if (dictionary == nil) {
        dictionary = [[NSMutableDictionary alloc] init];
  
        // Primary codes
        [dictionary setObject:@[@"93656"] forKey:@"afbAblationPrimaryCodes"];
        [dictionary setObject:@[@"93653"] forKey:@"svtAblationPrimaryCodes"];
        [dictionary setObject:@[@"93654"] forKey:@"vtAblationPrimaryCodes"];
        [dictionary setObject:@[@"93650"] forKey:@"avnAblationPrimaryCodes"];
        [dictionary setObject:@[@"93619", @"93620"] forKey:@"epTestingPrimaryCodes"];
        [dictionary setObject:@[@"33270", @"33271", @"33272", @"33273", @"0387T", @"0388T", @"0389T", @"0390T", @"0391T"] forKey:@"subQIcdPrimaryCodes"];
        [dictionary setObject:@[@"33282", @"33284", @"93660", @"92960", @"92961", @"76000"] forKey:@"otherProcedurePrimaryCodes"];
        [dictionary setObject:@[@"33206", @"33207", @"33208", @"33225"] forKey:@"newPpmPrimaryCodes"];
        [dictionary setObject:@[@"33227", @"33228", @"33229"] forKey:@"replacePpmPrimaryCodes"];
        [dictionary setObject:@[@"33249", @"33225"] forKey:@"newIcdPrimaryCodes"];
        [dictionary setObject:@[@"33262", @"33263", @"33264"] forKey:@"replaceIcdPrimaryCodes"];
        [dictionary setObject:@[@"33216", @"33217", @"33224", @"33215", @"33226", @"33233", @"33241", @"33234", @"33235", @"33244", @"33214", @"33206", @"33207", @"33208", @"33249", @"33225", @"33212", @"33213", @"33240", @"33230", @"33231", @"33222", @"33223", @"33218", @"33220"] forKey:@"upgradeSystemPrimaryCodes"];
 
        // Secondary codes
        [dictionary setObject:@[@"93655", @"93657", @"93609", @"93613", @"93621", @"93622", @"93623", @"93662", @"93462", @"36620"] forKey:@"ablationSecondaryCodes"];
        [dictionary setObject:@[@"93600", @"93619", @"93620", @"93609", @"93613", @"33207", @"33208", @"33210", @"33249", @"33225", @"92960", @"92961"] forKey:@"avnAblationSecondaryCodes"];
        [dictionary setObject:@[@"33210", @"33218", @"33220", @"92960", @"92961"] forKey:@"deviceSecondaryCodes"];
        [dictionary setObject:@[@"33210", @"33218", @"33220", @"92960", @"92961"] forKey:@"upgradeSystemSecondaryCodes"];
        [dictionary setObject:@[@"93641", @"33210", @"33999", @"92960", @"92961"] forKey:@"icdDeviceSecondaryCodes"];
        [dictionary setObject:@[@"93641", @"33210", @"33218", @"33220", @"92960", @"92961"] forKey:@"icdReplacementSecondaryCodes"];

        // Disabled codes
        [dictionary setObject:@[@"93621", @"93462"] forKey:@"afbAblationDisabledCodes"];
        [dictionary setObject:@[@"93657"] forKey:@"svtAblationDisabledCodes"];
        [dictionary setObject:@[@"93657", @"93609", @"93613", @"93622"] forKey:@"vtAblationDisabledCodes"];
        [dictionary setObject:@[@"93657", @"93655"] forKey:@"epTestingDisabledCodes"];
       
    }
    return dictionary;
}

+ (NSArray *)allCodesSorted
{
    NSDictionary *dictionary = [self allCodes];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[dictionary allValues]];
    NSArray *sortedCodes = [array sortedArrayUsingSelector:@selector(compareCodes:)];
    return sortedCodes;
}


+ (NSString *)codeNumberFromCodeString:(NSString *)codeString leavePlus:(BOOL)leavePlus {
    // assumes legitimate code string is passed, minimal error checking
    // takes something like "+99999-26 x 5" and returns simple code number "99999"
    // if leavePlus then returns "+99999" if plus present
    NSString *pureCodeNumber = @"";
    if ([codeString length] < 5) {
        return @"";
    }
    BOOL hasPlus = ([codeString characterAtIndex:0] == '+');
    if (hasPlus && [codeString length] < 6) {
        return @"";
    }
    if (hasPlus) {
        pureCodeNumber = [codeString substringWithRange:NSMakeRange(1, 5)];
    }
    else {
        pureCodeNumber = [codeString substringWithRange:NSMakeRange(0, 5)];
    }
    if (leavePlus && hasPlus) {
        pureCodeNumber = [NSString stringWithFormat:@"+%@", pureCodeNumber];
    }
    return pureCodeNumber;
}

+ (void)clearMultipliers:(NSArray *)array {
    for (EPSCode *code in array) {
        code.multiplier = 0;
    }
}

+ (void)clearModifiers:(NSArray *)array {
    for (EPSCode *code in array) {
        [code clearModifiers];
    }
}

+ (NSDictionary *)defaultModifiers
{
    static NSMutableDictionary *dictionary;
    if (dictionary == nil ) {
        dictionary = [[NSMutableDictionary alloc] init];
        // Modifer 26 alone
        NSMutableArray *modifierArray_26 = [[NSMutableArray alloc] init];
        // start with codes with 26 modifier as standard
        [modifierArray_26 addObject:[EPSModifiers getModifierForNumber:@"26"]];
        [dictionary setObject:modifierArray_26 forKey:@"93609"];
        [dictionary setObject:modifierArray_26 forKey:@"93620"];
        [dictionary setObject:modifierArray_26 forKey:@"93619"];
        [dictionary setObject:modifierArray_26 forKey:@"93621"];
        [dictionary setObject:modifierArray_26 forKey:@"93622"];
        [dictionary setObject:modifierArray_26 forKey:@"93662"];
        [dictionary setObject:modifierArray_26 forKey:@"76000"];
        [dictionary setObject:modifierArray_26 forKey:@"93641"];
        [dictionary setObject:modifierArray_26 forKey:@"93642"];
        [dictionary setObject:modifierArray_26 forKey:@"93660"];
        // Modifier 26 and 59
        NSMutableArray *modifierArray26_56 = [NSMutableArray arrayWithArray:modifierArray_26];
        [modifierArray26_56 addObject:[EPSModifiers getModifierForNumber:@"59"]];
        [dictionary setObject:modifierArray26_56 forKey:@"93623"];
        
        // Modifer Q0
        NSMutableArray *modifierArray_Q0 = [[NSMutableArray alloc] init];
        [modifierArray_Q0 addObject:[EPSModifiers getModifierForNumber:@"Q0"]];
        [dictionary setObject:modifierArray_Q0 forKey:@"33249"];
        [dictionary setObject:modifierArray_Q0 forKey:@"33262"];
        [dictionary setObject:modifierArray_Q0 forKey:@"33263"];
        [dictionary setObject:modifierArray_Q0 forKey:@"33264"];

        // Modifier 59
        NSMutableArray *modifierArray_59 = [[NSMutableArray alloc] init];
        [modifierArray_59 addObject:[EPSModifiers getModifierForNumber:@"59"]];
        [dictionary setObject:modifierArray_59 forKey:@"33222"];
        [dictionary setObject:modifierArray_59 forKey:@"33223"];
        [dictionary setObject:modifierArray_59 forKey:@"33620"];

    }
    return dictionary;
}



+ (void)clearMultipliersAndModifiers:(NSArray *)array {
    for (EPSCode *code in array) {
        code.multiplier = 0;
        [code clearModifiers];
    }
}

+ (void)loadDefaultModifiers:(NSArray *)codes {
    for (EPSCode *code in codes) {
        NSArray *modifiers = [[EPSCodes defaultModifiers] valueForKey:code.number];
        if (modifiers != nil) {
            [code addModifiers:modifiers];
        }
    }
}

+ (void)loadSavedModifiers:(NSArray *)codes {
    // TODO: expand to primary codes, sedation codes too?
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    for (EPSCode *code in codes) {
        NSArray *modifierNumbers = [defaults arrayForKey:code.number];
        if (modifierNumbers != nil) {
            // override default modifiers, just use saved modifiers, including no modifiers
            [code clearModifiers];
            for (NSString *modifierNumber in modifierNumbers) {
                EPSModifier *modifier = [EPSModifiers getModifierForNumber:modifierNumber];
                [code addModifier:modifier];
            }
        }
    }
}

+ (void)resetSavedModifiers:(NSArray *)codes {
    //TODO: expand to primary codes, etc.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    for (EPSCode *code in codes) {
        [defaults removeObjectForKey:code.number];
    }
}

@end
