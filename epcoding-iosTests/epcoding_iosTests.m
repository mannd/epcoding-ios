//
//  epcoding_iosTests.m
//  epcoding-iosTests
//
//  Created by David Mann on 10/14/13.
//  Copyright (c) 2013 David Mann. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EPSCode.h"

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

@end
