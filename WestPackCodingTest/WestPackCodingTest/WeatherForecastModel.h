//
//  WeatherForecastModel.h
//  WestpacCodingTest
//
//  Created by SunnyKumar on 10/30/15.
//  Copyright (c) 2015 TCS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherForecastModel : NSObject

@property (nonatomic,strong) NSString* summary;
@property (nonatomic,strong) NSString* windSpeed;
@property (nonatomic,strong) NSString* humidity;
@property (nonatomic,strong) NSString* timeZone;


@end
