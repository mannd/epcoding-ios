//
//  EPSCodes.m
//  EP Coding
//
//  Created by David Mann on 2/22/14.
//  Copyright (c) 2014 David Mann. All rights reserved.
//

#import "EPSCodes.h"

@implementation EPSCodes

+ (NSMutableDictionary *)allCodes
{
    static NSMutableDictionary *dictionary;
    if (dictionary == nil) {
        dictionary = [[NSMutableDictionary alloc] init];
        
        // SubQ ICD
        [self addCode:[[EPSCode alloc] initWithNumber:@"0319T" description:@"Implantation of SubQ ICD system (generator & electrode)" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"0320T" description:@"Insertion of SubQ defibrillator electrode only" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"0321T" description:@"Insertion of SubQ ICD generator only with existing electrode" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"0322T" description:@"Removal of SubQ ICD generator only" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"0323T" description:@"Removal and Replacement of SubQ ICD generator" isAddOn:NO] toDictionary:dictionary];
		[self addCode:[[EPSCode alloc] initWithNumber:@"0324T" description:@"Removal of SubQ ICD electrode" isAddOn:NO] toDictionary:dictionary];
		[self addCode:[[EPSCode alloc] initWithNumber:@"0325T" description:@"Repositioning of SubQ ICD electrode and/or generator" isAddOn:NO] toDictionary:dictionary];
		[self addCode:[[EPSCode alloc] initWithNumber:@"0326T" description:@"EP evaluation of SubQ ICD system" isAddOn:NO] toDictionary:dictionary];
		[self addCode:[[EPSCode alloc] initWithNumber:@"0327T" description:@"Interrogation of SubQ ICD system" isAddOn:NO] toDictionary:dictionary];
		[self addCode:[[EPSCode alloc] initWithNumber:@"0328T" description:@"Programming of SubQ ICD system" isAddOn:NO] toDictionary:dictionary];
		[self addCode:[[EPSCode alloc] initWithNumber:@"33206" description:@"New or replacement PPM with new A lead" isAddOn:NO] toDictionary:dictionary];
		[self addCode:[[EPSCode alloc] initWithNumber:@"33207" description:@"New or replacement PPM with new V lead" isAddOn:NO] toDictionary:dictionary];
		[self addCode:[[EPSCode alloc] initWithNumber:@"33208" description:@"New or replacement PPM with new A and V leads" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"33210" description:@"Insert temporary transvenous pacing electrode" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"33211" description:@"Insert temporary transvenous A and V pacing electrodes" isAddOn:NO] toDictionary:dictionary];
        
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
        [self addCode:[[EPSCode alloc] initWithNumber:@"36620" description:@"Arterial line placement" isAddOn:NO] toDictionary:dictionary];
        
        // note fluoroscopy included in device codes, but this code
        // used e.g to evaluate a lead such as a Riata
        [self addCode:[[EPSCode alloc] initWithNumber:@"76000" description:@"Fluoroscopic lead evaluation" isAddOn:NO] toDictionary:dictionary];
        // Ablation and EP testing codes
        
        // EP Testing and Mapping ///////////////////////
        [self addCode:[[EPSCode alloc] initWithNumber:@"93600" description:@"His bundle recording only" isAddOn:NO] toDictionary:dictionary];
        
        [self addCode:[[EPSCode alloc] initWithNumber:@"93609" description:@"2D mapping" isAddOn:YES] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"93613" description:@"3D mapping" isAddOn:YES] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"93619" description:@"EP testing without attempted arrhythmia induction" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"93620" description:@"EP testing with attempted arrhythmia induction" isAddOn:NO] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"93621" description:@"LA pacing & recording" isAddOn:YES] toDictionary:dictionary];
        [self addCode:[[EPSCode alloc] initWithNumber:@"93622" description:@"LV pacing & recording" isAddOn:YES] toDictionary:dictionary];
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
        
        // Unlisted procedure
        [self addCode:[[EPSCode alloc] initWithNumber:@"93799" description:@"Unlisted procedure" isAddOn:NO] toDictionary:dictionary];
    
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

+ (NSMutableDictionary *)getCodesForCodeNumbers:(NSArray *)codeNumbers {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    for (id codeNumber in codeNumbers)  {
        EPSCode *code = [EPSCodes getCodeForNumber:codeNumber];
        [dictionary setObject:code forKey:codeNumber];
    }
    return dictionary;
}



@end
