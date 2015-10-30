//
//  ServiceHandlerTest.m
//  WestpacCodingTest
//
//  Created by SunnyKumar on 10/30/15.
//  Copyright (c) 2015 TCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ServiceHandler.h"
#import "Constants.h"

@interface ServiceHandlerTest : XCTestCase

@property (nonatomic,strong) ServiceHandler* serviceHandlerTest;

@end

@implementation ServiceHandlerTest

- (void)setUp {
    [super setUp];
    self.serviceHandlerTest = [ServiceHandler sharedInstance];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.serviceHandlerTest = nil;
    [super tearDown];
}

/*
 
 Method Name  : testGetNSUrlForParameters
 Description  : to UNIT TEST getNSUrlForParameters of Service Handler
 
 */

-(void)testGetNSUrlForParameters
{
    NSURL* url = [self.serviceHandlerTest getNSUrlForParameters:@{kURL:Weather_Forecast_Url,kCoordinates:@"30.0,33.3"}];
    NSURL* testUrl =[NSURL URLWithString:[NSString stringWithFormat:@"%@30.0,33.3",Weather_Forecast_Url]];
    
    XCTAssertEqualObjects (url,testUrl,@"getNSUrlForParameters method is UNIT TESTED successfully");
}


@end
