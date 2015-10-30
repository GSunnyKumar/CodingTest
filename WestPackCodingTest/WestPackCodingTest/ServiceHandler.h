//
//  ServiceHandler.h
//  WestpacCodingTest
//
//  Created by SunnyKumar on 10/30/15.
//  Copyright (c) 2015 TCS. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ServiceHandler : NSObject

@property(nonatomic,copy) NSDictionary *(^onSuccess)(void) ;

@property(nonatomic,copy) NSError *(^onError)(void) ;

+(ServiceHandler*)sharedInstance;

-(NSURL*)getNSUrlForParameters:(NSDictionary*)parameterDict;

-(void)responseForURL:(NSURL*)url withSuccessHandler:(void (^)(NSDictionary*))onSuccess errorHandler:(void (^)(NSError*))onError;

@end
