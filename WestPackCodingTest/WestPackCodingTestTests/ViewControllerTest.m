//
//  ViewControllerTest.m
//  WestpacCodingTest
//
//  Created by SunnyKumar on 10/30/15.
//  Copyright (c) 2015 TCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ViewController.h"
#import "WeatherForecastModel.h"
#import "Constants.h"


@interface ViewController(Test)

-(void)setviewAttributes:(WeatherForecastModel*)weatherForecastModel;
-(NSString *)summaryLabelText;
-(NSString *)timezoneLabelText;
-(void)initializeViewAttributes;
-(WeatherForecastModel*)parseResponse:(NSDictionary*)responseDict;

@end

@interface ViewControllerTest : XCTestCase

@property (nonatomic,strong) ViewController* viewControllerTest;

@end

@implementation ViewControllerTest

- (void)setUp {
    [super setUp];
    self.viewControllerTest = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewController"];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.viewControllerTest = nil;
    [super tearDown];
}

/*
 
 Method Name  : testParseResonse
 Description  : to UNIT TEST parseResponse method in ViewController
 
 */

-(void)testParseResonse
{
    WeatherForecastModel* weatherModel = [self.viewControllerTest parseResponse:@{kTimeZone:@"India",kCurrently:@{@"summary":@"cloudy"}}];
    XCTAssertEqual(weatherModel.timeZone, @"India",@"ParseResponse method is Successfully Unit Tested");
    XCTAssertEqual(weatherModel.summary, @"cloudy",@"Pass");
    
}

/*
 
 Method Name  : testSetViewAttributes
 Description  : to UNIT TEST setviewAttributes in ViewController
 
 */

-(void)testSetViewAttributes
{
    WeatherForecastModel* weatherModel = [self.viewControllerTest parseResponse:@{kTimeZone:@"India",kCurrently:@{@"summary":@"cloudy"}}];
    [self.viewControllerTest setviewAttributes:weatherModel];
    XCTAssertEqual([self.viewControllerTest summaryLabelText],@"cloudy",@"setviewAttributes method is Successfully Unit Tested");
    XCTAssertEqual([self.viewControllerTest timezoneLabelText],@"India",@"setviewAttributes method is Successfully Unit Tested");
}


/*
 
 Method Name  : testInitializeViewAttributes
 Description  : to UNIT TEST initializeViewAttributes in ViewController
 
 */
-(void)testInitializeViewAttributes
{
    [self.viewControllerTest initializeViewAttributes];
    XCTAssertNil([self.viewControllerTest summaryLabelText],@"initializeViewAttributes method is Successfully Unit Tested");
    XCTAssertNil([self.viewControllerTest timezoneLabelText],@"initializeViewAttributes method is Successfully Unit Tested");
}


@end
