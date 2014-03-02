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
    XCTAssertTrue([[code description] isEqualToString:@"Test Code"], @"Test failed");
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
    code.description = @"This is an incredibly long description of a code, blah, blah, blah.";
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
}

- (void)testCodes
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [EPSCodes addCode:[[EPSCode alloc] initWithNumber:@"99999" description:@"Test Code" isAddOn:NO]toDictionary:dictionary];
    EPSCode *code = [dictionary objectForKey:@"99999"];
    XCTAssertTrue([code.description isEqualToString:@"Test Code"]);
    // test presence of specific codes
    NSDictionary *codeDictionary = [EPSCodes allCodes];
    EPSCode *code1 = [codeDictionary objectForKey:@"0319T"];
    XCTAssertTrue([code1.description isEqualToString:@"Implantation of SubQ ICD system (generator & electrode)"]);
    XCTAssertTrue([code1.number isEqualToString:@"0319T"]);
    XCTAssertFalse([code1 isAddOn]);
    EPSCode *code2 = [codeDictionary objectForKey:@"93624"];
    XCTAssertTrue([code2.description isEqualToString:@"Follow-up EP testing"]);
    XCTAssertTrue([code2.number isEqualToString:@"93624"]);
    XCTAssertFalse([code2 isAddOn]);
    EPSCode *code3 = [codeDictionary objectForKey:@"93622"];
    XCTAssertTrue([code3 isAddOn]);
    EPSCode *code4 = [EPSCodes getCodeForNumber:@"93624"];
    XCTAssertTrue([code4.description isEqualToString:@"Follow-up EP testing"]);
    XCTAssertTrue([code4.number isEqualToString:@"93624"]);
    XCTAssertFalse([code4 isAddOn]);
    NSArray *codeNumbers = @[@"0319T", @"93624", @"93622"];
    NSArray *codeArray2 = [EPSCodes getCodesForCodeNumbers:codeNumbers];
    EPSCode *newCode = [codeArray2 objectAtIndex:1];
    XCTAssertTrue([newCode.description isEqualToString:@"Follow-up EP testing"]);
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
    EPSCodeAnalyzer *analyzer = [[EPSCodeAnalyzer alloc] initWithPrimaryCodes:primaryCodes secondaryCodes:secondaryCodes ignoreNoSecondaryCodes:NO];
    XCTAssertTrue([[analyzer allCodes] count] == 6);
    XCTAssertTrue([[[[analyzer allCodes] objectAtIndex:3] number] isEqualToString:@"00003"]);
    XCTAssertTrue([[[[analyzer allCodes] objectAtIndex:5] description] isEqualToString:@"testcode5"]);
    NSArray *allCodeNumbers = [analyzer allCodeNumbers];
    XCTAssertTrue([[allCodeNumbers objectAtIndex:0] isEqualToString:@"00000"]);
    XCTAssertTrue([[allCodeNumbers objectAtIndex:5] isEqualToString:@"00005"]);
    XCTAssertTrue(![analyzer allAddOnCodes]);
    for (EPSCode *code in [analyzer allCodes]) {
        code.isAddOn = YES;
    }
    XCTAssertTrue([analyzer allAddOnCodes]);
    EPSCodeAnalyzer *analyzer1 = [[EPSCodeAnalyzer alloc] initWithPrimaryCodes:nil secondaryCodes:nil ignoreNoSecondaryCodes:YES];
    NSArray *results = [analyzer1 analysis];
    XCTAssertTrue([results count] == 1);
    XCTAssertTrue([[[results objectAtIndex:0] message] isEqualToString:@"No codes selected."]);
    XCTAssertTrue([[results objectAtIndex:0] warningLevel] == WARNING);
    NSArray *codeNumbers = [analyzer codeNumbersFromCodes:primaryCodes];
    XCTAssertTrue([[codeNumbers objectAtIndex:2] isEqualToString:@"00002"]);
    // note there is space after terminal "]" in next method
    XCTAssertTrue([[analyzer1 codeNumbersToString:codeNumbers] isEqualToString:@"[00000,00001,00002] "]);
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

@end
