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
}

- (void)testCodes
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [EPSCodes addCode:[[EPSCode alloc] initWithNumber:@"99999" description:@"Test Code" isAddOn:NO]toDictionary:dictionary];
    EPSCode *code = [dictionary objectForKey:@"99999"];
    XCTAssertTrue([code.description isEqualToString:@"Test Code"]);
    // test presence of specific codes
    NSMutableDictionary *codeDictionary = [EPSCodes allCodes];
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
    NSMutableDictionary *codeDictionary2 = [EPSCodes getCodesForCodeNumbers:codeNumbers];
    EPSCode *newCode = [codeDictionary2 valueForKey:@"93624"];
    XCTAssertTrue([newCode.description isEqualToString:@"Follow-up EP testing"]);
    EPSCode *newCode2 = [codeDictionary2 valueForKey:@"93622"];
    XCTAssertTrue([newCode2.number isEqualToString:@"93622"]);

    
    
}

@end
