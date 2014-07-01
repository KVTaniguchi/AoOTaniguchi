//
//  KTStoreTester.m
//  AoOTaniguchi
//
//  Created by Kevin Taniguchi on 7/1/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KTCurrencyStore.h"

@interface KTStoreTester : XCTestCase

@end

@implementation KTStoreTester

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

-(void)currencyStoreReturnsANumber{
    NSNumber *testNum = [NSNumber new];
    testNum = [[KTCurrencyStore sharedStore]convertDollarAmount:@"1" ForDenom:@"JPY"];
    XCTAssertTrue([testNum isKindOfClass:[NSNumber class]], @"The store should be storing NSNumbers loaded from the api");
}

-(void)currencyStoreSavesCurrencyValue{
    Currency *testMoney = [Currency new];
    testMoney = [[KTCurrencyStore sharedStore]updateCurrency];
    XCTAssertTrue(testMoney.value > 0, @"should not be nil, should have a value");
}

- (void)testExample
{
    NSNumber *testNum = [NSNumber new];
    testNum = [[KTCurrencyStore sharedStore]convertDollarAmount:@"1" ForDenom:@"JPY"];
    XCTAssertTrue([testNum isKindOfClass:[NSNumber class]], @"The store should be storing NSNumbers loaded from the api");
}

@end
