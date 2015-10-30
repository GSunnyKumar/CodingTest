//
//  ServiceHandler.m
//  WestpacCodingTest
//
//  Created by SunnyKumar on 10/30/15.
//  Copyright (c) 2015 TCS. All rights reserved.
//

#import "ServiceHandler.h"
#import "Constants.h"

@interface ServiceHandler()

@property (nonatomic,strong) NSURLSession * session;

@end

@implementation ServiceHandler

static ServiceHandler *sharedInstance = nil;

/*
 
 Method Name  : sharedInstance
  Description  : to get shared instance for Service handler
 
 */

+(ServiceHandler*)sharedInstance
{
    if(sharedInstance == nil)
    {
        sharedInstance = [[ServiceHandler alloc]init];
    }
    return sharedInstance;
}

/*
 
 Method Name  : getNSUrlForParameters
 Parameters   : NSDictionary contains parameters to prepare URL
 Return       : NSURL with specified Parameters
 Description  : to construct URL
 
 */

-(NSURL*)getNSUrlForParameters:(NSDictionary*)parameterDict
{
    NSString* urlString = [NSString stringWithFormat:@"%@%@",parameterDict[kURL],parameterDict[kCoordinates]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    return url;
}

/*
 
 Method Name  : responseForURL withSuccessHandler errorHandler
 Parameters   : NSURL successhandler errorhandler
 Description  : to response for URL specified
 
 */

-(void)responseForURL:(NSURL*)url withSuccessHandler:(void (^)(NSDictionary*))onSuccess errorHandler:(void (^)(NSError*))onError
{
    NSURLSession * session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask * dataTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
         if(!response||statusCode >= 400)
         {
             onError(error);
         }
         else
         {
             NSDictionary * responseDict = nil;
             if(data.length>1)
             {
                 responseDict  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                 onSuccess(responseDict);
             }else
             {
                 onError(error);
             }
         }
    }];
    [dataTask resume] ;
}

@end
