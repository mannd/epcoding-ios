//
//  epcoding_iosTests.m
//  epcoding-iosTests
//
//  Created by David Mann on 10/14/13.
//  Copyright (c) 2013 David Mann. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EPSCode.h"
#import "EPSCodes.h"
#import "EPSProcedureKey.h"
#import "EPSProcedureKeys.h"
#import "EPSCodeAnalyzer.h"
#import "EPSCodeError.h"
#import "EPSModifier.h"
#import "EPSSedationCode.h"

@interface epcoding_iosTests : XCTestCase

@end

@implementation epcoding_iosTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//- (void)testExample
//{
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
//}

- (void)testCode
{
    EPSCode *code = [[EPSCode alloc] initWithNumber:@"99999" description:@"Test Code" isAddOn:YES];
    XCTAssertTrue([[code number] isEqualToString:@"99999"], @"Test failed");
    XCTAssertTrue([[code fullDescription] isEqualToString:@"Test Code"], @"Test failed");
    XCTAssertTrue([code isAddOn], @"Test failed");
    XCTAssertTrue([[code unformattedCodeNumberFirst] isEqualToString:@"(+99999) Test Code"]);
    code.plusShown = YES;
    XCTAssertTrue([[code unformattedCodeDescriptionFirst] isEqualToString:@"Test Code (+99999)"]);
    code.descriptonShown = YES;
    code.descriptionShortened = NO;
    XCTAssertTrue([[code formattedCode] isEqualToString:@"(+99999) Test Code"]);
    code.plusShown = NO;
    XCTAssertTrue([[code formattedCode] isEqualToString:@"(99999) Test Code"]);
    code.isAddOn = NO;
    XCTAssertTrue([[code unformattedCodeNumberFirst] isEqualToString:@"(99999) Test Code"]);
    code.plusShown = YES;
    XCTAssertTrue([[code unformattedCodeDescriptionFirst] isEqualToString:@"Test Code (99999)"]);
    XCTAssertTrue([[code formattedCode] isEqualToString:@"(99999) Test Code"]);
    code.plusShown = NO;
    XCTAssertTrue([[code formattedCode] isEqualToString:@"(99999) Test Code"]);
    code.isAddOn = YES;
    code.plusShown = YES;
    code.fullDescription = @"This is an incredibly long description of a code, blah, blah, blah.";
    XCTAssertTrue([[code formattedCode] isEqualToString:@"(+99999) This is an incredibly long description of a code, blah, blah, blah."]);
    code.descriptonShown = NO;
    XCTAssertTrue([[code formattedCode] isEqualToString:@"(+99999)"]);
    code.descriptonShown = YES;
    code.descriptionShortened = YES;
    XCTAssertTrue([[code formattedCode] isEqualToString:@"(+99999) This is an incredibly..."]);
    XCTAssertTrue([[code unformattedCodeNumber] isEqualToString:@"+99999"]);
    // test mark code status only goes up in threat level
    EPSCode *codeGreen = [[EPSCode alloc] initWithNumber:@"10000" description:@"start green" isAddOn:NO];
    XCTAssertTrue(codeGreen.codeStatus == GOOD);
    [codeGreen markCodeStatus:WARNING];
    XCTAssertTrue(codeGreen.codeStatus == WARNING);
    [codeGreen markCodeStatus:GOOD];
    XCTAssertTrue(codeGreen.codeStatus == WARNING);
    [codeGreen markCodeStatus:ERROR];
    XCTAssertTrue(codeGreen.codeStatus == ERROR);
    [codeGreen markCodeStatus:WARNING];
    XCTAssertTrue(codeGreen.codeStatus == ERROR);
    NSArray *codes = @[code, codeGreen];
    XCTAssertTrue([codes indexOfObjectIdenticalTo:code] == 0);
    NSArray *sortedCodes = [codes sortedArrayUsingSelector:@selector(compareCodes:)];
    XCTAssertTrue([sortedCodes indexOfObjectIdenticalTo:code] == 1);

    
}

- (void)testCodes
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [EPSCodes addCode:[[EPSCode alloc] initWithNumber:@"99999" description:@"Test Code" isAddOn:NO]toDictionary:dictionary];
    EPSCode *code = [dictionary objectForKey:@"99999"];
    XCTAssertTrue([code.fullDescription isEqualToString:@"Test Code"]);
    // test presence of specific codes
    NSDictionary *codeDictionary = [EPSCodes allCodes];
    EPSCode *code1 = [codeDictionary objectForKey:@"33270"];
    XCTAssertTrue([code1.fullDescription isEqualToString:@"New or replacement SubQ ICD system, includes testing"]);
    XCTAssertTrue([code1.number isEqualToString:@"33270"]);
    XCTAssertFalse([code1 isAddOn]);
    EPSCode *code2 = [codeDictionary objectForKey:@"93624"];
    XCTAssertTrue([code2.fullDescription isEqualToString:@"Follow-up EP testing"]);
    XCTAssertTrue([code2.number isEqualToString:@"93624"]);
    XCTAssertFalse([code2 isAddOn]);
    EPSCode *code3 = [codeDictionary objectForKey:@"93622"];
    XCTAssertTrue([code3 isAddOn]);
    EPSCode *code4 = [EPSCodes getCodeForNumber:@"93624"];
    XCTAssertTrue([code4.fullDescription isEqualToString:@"Follow-up EP testing"]);
    XCTAssertTrue([code4.number isEqualToString:@"93624"]);
    XCTAssertFalse([code4 isAddOn]);
    NSArray *codeNumbers = @[@"33270", @"93624", @"93622"];
    NSArray *codeArray2 = [EPSCodes getCodesForCodeNumbers:codeNumbers];
    EPSCode *newCode = [codeArray2 objectAtIndex:1];
    XCTAssertTrue([newCode.fullDescription isEqualToString:@"Follow-up EP testing"]);
    EPSCode *newCode2 = [codeArray2 objectAtIndex:2];
    XCTAssertTrue([newCode2.number isEqualToString:@"93622"]);
    NSArray *ablationCodes = [[EPSCodes codeDictionary] valueForKey:@"afbAblationPrimaryCodes"];
    XCTAssertTrue([[ablationCodes objectAtIndex:0] isEqualToString:@"93656"]);
    NSArray *disabledAblationCodes = [[EPSCodes codeDictionary] valueForKey:@"afbAblationDisabledCodes"];
    XCTAssertTrue([[disabledAblationCodes objectAtIndex:0] isEqualToString:@"93621"]);
 
    // TODO do this test when sorting implemented
    //NSMutableArray *sortedCodes = [EPSCodes allCodesSorted];
    // EPSCode *code10 = [sortedCodes objectAtIndex:0];
    // this is what it should be, but codes are sorted yet
    // XCTAssertTrue([[[sortedCodes objectAtIndex:0] number] isEqualToString:@"0319T"]);
    // XCTAssertTrue([[code10 number] isEqualToString:@"33264"]);
}

- (void)testProcedureKeys
{
    NSDictionary *dictionary = [EPSProcedureKeys keyDictionary];
    XCTAssertTrue([[[dictionary objectForKey:SVT_ABLATION_TITLE] secondaryCodesKey] isEqualToString:@"ablationSecondaryCodes"]);
    XCTAssertTrue([[[dictionary objectForKey:VT_ABLATION_TITLE] secondaryCodesKey] isEqualToString:@"ablationSecondaryCodes"]);
    XCTAssertTrue([[dictionary objectForKey:SVT_ABLATION_TITLE] disablePrimaryCodes] == YES);
    XCTAssertTrue([[[dictionary objectForKey:OTHER_PROCEDURE_TITLE] secondaryCodesKey] isEqualToString:NO_CODE_KEY]);
}

- (void)testCodeAnalyzer
{
    EPSCode *code = [[EPSCode alloc] initWithNumber:@"00000" description:@"test code" isAddOn:NO];
    XCTAssertTrue(code.codeStatus == GOOD);
    [code setCodeStatus:ERROR];
    XCTAssertTrue(code.codeStatus == ERROR);
    // construct test code sets
    EPSCode *code0 = [[EPSCode alloc] initWithNumber:@"00000" description:@"testcode0" isAddOn:NO];
    EPSCode *code1 = [[EPSCode alloc] initWithNumber:@"00001" description:@"testcode1" isAddOn:NO];
    EPSCode *code2 = [[EPSCode alloc] initWithNumber:@"00002" description:@"testcode2" isAddOn:NO];
    EPSCode *code3 = [[EPSCode alloc] initWithNumber:@"00003" description:@"testcode3" isAddOn:NO];
    EPSCode *code4 = [[EPSCode alloc] initWithNumber:@"00004" description:@"testcode4" isAddOn:NO];
    EPSCode *code5 = [[EPSCode alloc] initWithNumber:@"00005" description:@"testcode5" isAddOn:NO];
    NSArray *primaryCodes = @[code0, code1, code2];
    NSArray *secondaryCodes = @[code3, code4, code5];
    EPSCodeAnalyzer *analyzer = [[EPSCodeAnalyzer alloc] initWithPrimaryCodes:primaryCodes secondaryCodes:secondaryCodes  ignoreNoSecondaryCodes:NO sedationCodes:nil sedationStatus:Unassigned];
    XCTAssertTrue([[analyzer allCodes] count] == 6);
    XCTAssertTrue([[[[analyzer allCodes] objectAtIndex:3] number] isEqualToString:@"00003"]);
    XCTAssertTrue([[[[analyzer allCodes] objectAtIndex:5] fullDescription] isEqualToString:@"testcode5"]);
    NSArray *allCodeNumbers = [analyzer allCodeNumbers];
    XCTAssertTrue([[allCodeNumbers objectAtIndex:0] isEqualToString:@"00000"]);
    XCTAssertTrue([[allCodeNumbers objectAtIndex:5] isEqualToString:@"00005"]);
    XCTAssertTrue(![analyzer allAddOnCodes]);
    for (EPSCode *code in [analyzer allCodes]) {
        code.isAddOn = YES;
    }
    XCTAssertTrue([analyzer allAddOnCodes]);
    EPSCodeAnalyzer *analyzer1 = [[EPSCodeAnalyzer alloc] initWithPrimaryCodes:nil secondaryCodes:nil ignoreNoSecondaryCodes:YES sedationCodes:nil sedationStatus:Unassigned];
    NSArray *results = [analyzer1 analysis];
    XCTAssertTrue([results count] == 1);
    XCTAssertTrue([[[results objectAtIndex:0] message] isEqualToString:@"No codes selected."]);
    XCTAssertTrue([[results objectAtIndex:0] warningLevel] == WARNING);
    NSArray *codeNumbers = [analyzer codeNumbersFromCodes:primaryCodes];
    XCTAssertTrue([[codeNumbers objectAtIndex:2] isEqualToString:@"00002"]);
    // note there is space after terminal "]" in next method
    XCTAssertTrue([[EPSCodeAnalyzer codeNumbersToString:codeNumbers] isEqualToString:@"[00000,00001,00002]"]);
    EPSCode *afbAblationCode = [[EPSCode alloc] initWithNumber:@"93653" description:nil isAddOn:NO];
    EPSCodeAnalyzer *analyzer2 = [[EPSCodeAnalyzer alloc] initWithPrimaryCodes:@[afbAblationCode] secondaryCodes:nil ignoreNoSecondaryCodes:NO sedationCodes:nil sedationStatus:Unassigned];
    XCTAssertTrue([analyzer2 noMappingCodesForAblation]);
    EPSCode *twoDMappingCode = [[EPSCode alloc] initWithNumber:@"93609" description:nil isAddOn:NO];
    EPSCodeAnalyzer *analyzer3 = [[EPSCodeAnalyzer alloc] initWithPrimaryCodes:@[afbAblationCode] secondaryCodes:@[twoDMappingCode] ignoreNoSecondaryCodes:NO sedationCodes:nil sedationStatus:Unassigned];
    XCTAssertFalse([analyzer3 noMappingCodesForAblation]);
    NSSet *codeNumberSet = [NSSet setWithArray:@[@"00000", @"00001", @"00002", @"00003"]];
    NSArray *badCodes = @[@"00000", @"00002"];
    NSArray *badCodeResult = [analyzer codesWithBadCombosFromCodeSet:codeNumberSet andBadCodeNumbers:badCodes];
    NSLog(@"Bad codes = %@", [EPSCodeAnalyzer codeNumbersToString:badCodeResult]);
    // make sure unmatched codes are stripped off
    NSArray *newBadCodes = @[@"00000", @"00001", @"99999"];
    NSArray *badCodeResult2 = [analyzer codesWithBadCombosFromCodeSet:codeNumberSet andBadCodeNumbers:newBadCodes];
    XCTAssertTrue([[EPSCodeAnalyzer codeNumbersToString:badCodeResult2] isEqualToString:@"[00000,00001]"]);
    EPSCode *code01 = [[EPSCode alloc] initWithNumber:@"33233" description:@"testcode0" isAddOn:NO];
    EPSCode *code02 = [[EPSCode alloc] initWithNumber:@"33228" description:@"testcode0" isAddOn:NO];
    EPSCode *code03 = [[EPSCode alloc] initWithNumber:@"00000" description:@"testcode0" isAddOn:NO];
    NSArray *primaryCodes1 = @[code01, code02, code03];
    EPSCode *codeSedation01 = [[EPSCode alloc] initWithNumber:@"99152" description:@"sedationcode" isAddOn:NO];
    NSArray *sedationCodes = @[codeSedation01];
    EPSCodeAnalyzer *analyzer5 = [[EPSCodeAnalyzer alloc] initWithPrimaryCodes:primaryCodes1 secondaryCodes:secondaryCodes ignoreNoSecondaryCodes:NO sedationCodes:sedationCodes sedationStatus:Unassigned];
    NSArray *errorCodes = [analyzer5 analysis];
    EPSCodeError *errorCode1 = [errorCodes objectAtIndex:0];
    NSArray *codes10 = [errorCode1 codes];
    NSLog(@"%@", [EPSCodeAnalyzer codeNumbersToString:codes10]);
    XCTAssertTrue([[EPSCodeAnalyzer codeNumbersToString:codes10] isEqualToString:@"[33233,33228]"]);
    XCTAssertTrue([EPSCodeAnalyzer codeNumbersToString:nil] == nil);
    
    

}

- (void)testCodeError
{
    EPSCode *code0 = [[EPSCode alloc] initWithNumber:@"00000" description:@"testcode0" isAddOn:NO];
    EPSCode *code1 = [[EPSCode alloc] initWithNumber:@"00001" description:@"testcode1" isAddOn:NO];
    EPSCode *code2 = [[EPSCode alloc] initWithNumber:@"00002" description:@"testcode2" isAddOn:NO];
    EPSCode *code3 = [[EPSCode alloc] initWithNumber:@"00003" description:@"testcode3" isAddOn:NO];
    EPSCode *code4 = [[EPSCode alloc] initWithNumber:@"00004" description:@"testcode4" isAddOn:NO];
    EPSCode *code5 = [[EPSCode alloc] initWithNumber:@"00005" description:@"testcode5" isAddOn:NO];
    NSMutableArray *codes = [NSMutableArray arrayWithArray:@[code0, code1, code2, code3, code4, code5]];
    EPSCodeError *codeError = [[EPSCodeError alloc] initWithCodes:codes withWarningLevel:ERROR withMessage:@"This is a test error."];
    XCTAssertTrue([codeError warningLevel] == ERROR);
    NSMutableArray *array = [codeError codes];
    XCTAssertTrue([[[array objectAtIndex:1] number] isEqualToString:@"00001"]);
}

- (void)testCodeMultiplier {
    XCTAssert([EPSSedationCode codeMultiplier:40] == 2);
    XCTAssert([EPSSedationCode codeMultiplier:37] == 1);
    XCTAssert([EPSSedationCode codeMultiplier:22] == 0);
    XCTAssert([EPSSedationCode codeMultiplier:23] == 1);
    XCTAssert([EPSSedationCode codeMultiplier:38] == 2);
    XCTAssert([EPSSedationCode codeMultiplier:67] == 3);
    XCTAssert([EPSSedationCode codeMultiplier:68] == 4);
    XCTAssert([EPSSedationCode codeMultiplier:81] == 4);
    XCTAssert([EPSSedationCode codeMultiplier:10] == 0);
    XCTAssert([EPSSedationCode codeMultiplier:0] == 0);
    XCTAssert([EPSSedationCode codeMultiplier:-10] == 0);
}

//+ (NSString *)codeNumberFromCodeString:(NSString *)codeString leavePlus:(BOOL)leavePlus {
- (void)testCodeNumberFromCodeString {
    NSString *testString = [EPSCodes codeNumberFromCodeString:@"+88888-26 x 5" leavePlus:YES];
    XCTAssertTrue([testString isEqualToString:@"+88888"]);
    testString = [EPSCodes codeNumberFromCodeString:@"+88888-26 x 5" leavePlus:NO];
    XCTAssertTrue([testString isEqualToString:@"88888"]);
    testString = [EPSCodes codeNumberFromCodeString:@"77777" leavePlus:YES];
    XCTAssertTrue([testString isEqualToString:@"77777"]);
    testString = [EPSCodes codeNumberFromCodeString:@"+8888" leavePlus:NO];
    XCTAssertTrue([testString isEqualToString:@""]);
    testString = [EPSCodes codeNumberFromCodeString:@"+88" leavePlus:YES];
    XCTAssertTrue([testString isEqualToString:@""]);
}

- (void)testModifiers {
    EPSCode *testCode = [[EPSCode alloc] initWithNumber:@"99999" description:@"Test code" isAddOn:NO];
    EPSModifier *testModifier = [[EPSModifier alloc] initWithNumber:@"99" andDescription:@"Test modifier"];
    XCTAssertTrue([testModifier.fullDescription isEqualToString:@"Test modifier"]);
    [testCode addModifier:testModifier];
    NSString *testCodeString = [testCode unformattedCodeNumber];
    XCTAssertTrue([testCodeString isEqualToString:@"99999-99"]);
    [testCode clearModifiers];
    testCodeString = [testCode unformattedCodeNumber];
    XCTAssertTrue([testCodeString isEqualToString:@"99999"]);
    EPSModifier *testModifier2 = [[EPSModifier alloc] initWithNumber:@"88" andDescription:@"Test modifier 2"];
    [testCode addModifier:testModifier2];
    [testCode addModifier:testModifier];
    testCodeString = [testCode unformattedCodeNumber];
    NSLog(@"%@", testCodeString);
    XCTAssertTrue([testCodeString isEqualToString:@"99999-88-99"]);
    testCode.multiplier = 20;
    testCodeString = [testCode unformattedCodeNumber];
    XCTAssertTrue([testCodeString isEqualToString:@"99999-88-99 x 20"]);
    [testCode clearModifiers];
    testCodeString = [testCode unformattedCodeNumber];
    XCTAssertTrue([testCodeString isEqualToString:@"99999 x 20"]);
    [testCode addModifier:testModifier];
    XCTAssertTrue([testCode.modifiers count] == 1);
    EPSModifier *modifier = [[testCode modifiers] objectAtIndex:0];
    NSLog(@"modifier description = %@", modifier.fullDescription);
    XCTAssertTrue([modifier.fullDescription isEqualToString:@"Test modifier"]);
    // prevent duplicate modifiers
    [testCode clearModifiers];
    testCode.multiplier = 0;
    [testCode addModifier:testModifier];
    [testCode addModifier:testModifier];
    XCTAssertTrue([testCode.modifiers count] == 1);
    XCTAssertTrue([[testCode unformattedCodeNumber] isEqualToString:@"99999-99"]);
}

- (void)testSedationCodes {
    NSInteger time = 23;
    BOOL sameMD = YES;
    BOOL ptOver5 = YES;
    NSArray *sedationCodes = [EPSSedationCode sedationCoding:time sameMD:sameMD patientOver5:ptOver5];
    XCTAssertTrue([sedationCodes count] == 2);
    EPSCode *code1 = [sedationCodes objectAtIndex:0];
    EPSCode *code2 = [sedationCodes objectAtIndex:1];
    XCTAssertTrue([[code1 unformattedCodeNumber] isEqualToString:@"99152"]);
    XCTAssertTrue([[code2 unformattedCodeNumber] isEqualToString:@"+99153 x 1"]);
    time = 55;
    sedationCodes = [EPSSedationCode sedationCoding:time sameMD:sameMD patientOver5:ptOver5];
    code1 = [sedationCodes objectAtIndex:0];
    code2 = [sedationCodes objectAtIndex:1];
    XCTAssertTrue([[code1 unformattedCodeNumber] isEqualToString:@"99152"]);
    XCTAssertTrue([[code2 unformattedCodeNumber] isEqualToString:@"+99153 x 3"]);
    time = 70;
    sedationCodes = [EPSSedationCode sedationCoding:time sameMD:sameMD patientOver5:ptOver5];
    code1 = [sedationCodes objectAtIndex:0];
    code2 = [sedationCodes objectAtIndex:1];
    XCTAssertTrue([[code1 unformattedCodeNumber] isEqualToString:@"99152"]);
    XCTAssertTrue([[code2 unformattedCodeNumber] isEqualToString:@"+99153 x 4"]);
    sameMD = NO;
    sedationCodes = [EPSSedationCode sedationCoding:time sameMD:sameMD patientOver5:ptOver5];
    code1 = [sedationCodes objectAtIndex:0];
    code2 = [sedationCodes objectAtIndex:1];
    NSLog(@"%@", [code1 unformattedCodeNumber]);
    XCTAssertTrue([[code1 unformattedCodeNumber] isEqualToString:@"99156"]);
    XCTAssertTrue([[code2 unformattedCodeNumber] isEqualToString:@"+99157 x 4"]);
    ptOver5 = NO;
    sedationCodes = [EPSSedationCode sedationCoding:time sameMD:sameMD patientOver5:ptOver5];
    code1 = [sedationCodes objectAtIndex:0];
    code2 = [sedationCodes objectAtIndex:1];
    XCTAssertTrue([[code1 unformattedCodeNumber] isEqualToString:@"99155"]);
    XCTAssertTrue([[code2 unformattedCodeNumber] isEqualToString:@"+99157 x 4"]);
    sameMD = YES;
    sedationCodes = [EPSSedationCode sedationCoding:time sameMD:sameMD patientOver5:ptOver5];
    code1 = [sedationCodes objectAtIndex:0];
    code2 = [sedationCodes objectAtIndex:1];
    XCTAssertTrue([[code1 unformattedCodeNumber] isEqualToString:@"99151"]);
    XCTAssertTrue([[code2 unformattedCodeNumber] isEqualToString:@"+99153 x 4"]);
    time = 0;
    sedationCodes = [EPSSedationCode sedationCoding:time sameMD:sameMD patientOver5:ptOver5];
    XCTAssertTrue([sedationCodes count] == 0);
    time = 22;
    sedationCodes = [EPSSedationCode sedationCoding:time sameMD:sameMD patientOver5:ptOver5];
    XCTAssertTrue([sedationCodes count] == 1);
    time = 23;
    sedationCodes = [EPSSedationCode sedationCoding:time sameMD:sameMD patientOver5:ptOver5];
    XCTAssertTrue([sedationCodes count] == 2);
}

- (void)testSedationDetail {
    SedationStatus status = Unassigned;
    EPSCode *code1 = nil;
    EPSCode *code2 = nil;
    NSArray *codes = [NSArray arrayWithObjects:code1, code2, nil];
    NSString *detail = [EPSSedationCode sedationDetail:codes sedationStatus:status];
    XCTAssert(detail == UNASSIGNED_SEDATION_STRING);
    codes = [EPSSedationCode sedationCoding:23 sameMD:YES patientOver5:YES];
    detail = [EPSSedationCode sedationDetail:codes sedationStatus:AssignedSameMD];
    XCTAssert([detail isEqualToString:@"99152, +99153 x 1"]);
    codes = [EPSSedationCode sedationCoding:23 sameMD:NO patientOver5:YES];
    detail = [EPSSedationCode sedationDetail:codes sedationStatus:OtherMDCalculated];
    NSString *result = [NSString stringWithFormat:OTHER_MD_CALCULATED_SEDATION_TIME_STRING, @"99156, +99157 x 1"];
    XCTAssert([detail isEqualToString:result]);
    detail = [EPSSedationCode sedationDetail:codes sedationStatus:None];
    XCTAssert(detail == NO_SEDATION_STRING);
    detail = [EPSSedationCode sedationDetail:nil sedationStatus:LessThan10Mins];
    XCTAssert(detail == SHORT_SEDATION_TIME_STRING);
    detail = [EPSSedationCode sedationDetail:codes sedationStatus:OtherMDUnCalculated];
    XCTAssert(detail == OTHER_MD_UNCALCULATED_SEDATION_TIME_STRING);
}

- (void)testPrintSedationCodes {
    NSArray *codes = @[[EPSCodes getCodeForNumber:@"99152"], [EPSCodes getCodeForNumber:@"99153"]];
    NSString *result = [EPSSedationCode printSedationCodesWithDescriptions:codes];
    NSLog(@"%@", result);
    NSString *predictedResult = @"99152 (Mod sedation, same MD, initial 15 min, pt ≥ 5 y/o) and +99153 (Mod sedation, same MD, each additional 15 min)";
    XCTAssert([result isEqualToString:predictedResult]);
    codes = @[[EPSCodes getCodeForNumber:@"99152"]];
    result = [EPSSedationCode printSedationCodesWithDescriptions:codes];
    predictedResult = @"99152 (Mod sedation, same MD, initial 15 min, pt ≥ 5 y/o)";
    XCTAssert([result isEqualToString:predictedResult]);
}

@end
