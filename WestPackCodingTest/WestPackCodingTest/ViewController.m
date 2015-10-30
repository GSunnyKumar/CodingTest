//
//  ViewController.m
//  WestpacCodingTest
//
//  Created by SunnyKumar on 10/30/15.
//  Copyright (c) 2015 TCS. All rights reserved.
//

#import "ViewController.h"
#import "ServiceHandler.h"
#import "WeatherForecastModel.h"
#import "Constants.h"


@interface ViewController ()<CLLocationManagerDelegate>

@property (nonatomic,strong) ServiceHandler *serviceHandler;
@property (nonatomic,strong) WeatherForecastModel* weatherForeCastModel;
@property (nonatomic,strong) NSDictionary* weatherSummaryDictionary;
@property (nonatomic,strong) CLLocationManager *cLLocationManager;
@property (nonatomic,strong) NSString* coordinates;
@property (weak, nonatomic) IBOutlet UILabel *timezoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *windSpeedLabel;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)refreshButtonaction:(id)sender;

@end


@implementation ViewController

#pragma mark -- View Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.serviceHandler = [ServiceHandler sharedInstance];
    [self initializeViewAttributes];
    if ([self.cLLocationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [self.cLLocationManager requestAlwaysAuthorization];
    }
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self updateUserInterfaceForWeatherForecastServiceCall:NO];
    [self.cLLocationManager startUpdatingLocation];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.cLLocationManager stopUpdatingLocation];
}

/*
 
 Method Name  : weatherSummaryDictionary
 Description  : getter for weathesummaryDictionary
 
 */

-(NSDictionary*)weatherSummaryDictionary
{
    if(!_weatherSummaryDictionary)
    {
        _weatherSummaryDictionary = [NSDictionary dictionaryWithObjectsAndKeys:kClearDay,[UIColor lightGrayColor], kClearNight,[UIColor grayColor],kRainy,[UIColor greenColor],kSnow,[UIColor lightGrayColor],kSleet,[UIColor purpleColor],kFog,[UIColor greenColor],kCloudy,[UIColor grayColor],nil];
    }
    return _weatherSummaryDictionary;
}

/*
 
 Method Name  : cLLocationManager
 Description  : getter for weathesummaryDictionary
 
 */

-(CLLocationManager*)cLLocationManager{
    
    if(!_cLLocationManager)
    {
        _cLLocationManager = [[CLLocationManager alloc] init];
        _cLLocationManager.delegate = self;
        _cLLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return _cLLocationManager;
    
}

/*
 
 Method Name  : initializeViewAttributes
 Description  : to initialize view attribtes
 
 */

-(void)initializeViewAttributes
{
    self.summaryLabel.text      = @"";
    self.windSpeedLabel.text    = @"";
    self.humidityLabel.text     = @"";
    self.timezoneLabel.text     = @"";
}

#pragma mark -- CLLocationManager Delegate Methods

/*
 
 Method Name  : locationManager didUpdateLocations
 Parameters   : CLLocationManager instance and locations array
 Description  : to initialize view attribtes
 
 */

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *curLocation = [locations lastObject];
    
    NSLog(@"%@ response",curLocation);
    
    self.coordinates = [NSString stringWithFormat:@"%f,%f", curLocation.coordinate.latitude, curLocation.coordinate.longitude];
    if(self.coordinates.length>1)
    {
        [self updateUserInterfaceForWeatherForecastServiceCall:YES];
        [self getCurrentWeatherForecastDetails];
    }else{
        [self updateUserInterfaceForWeatherForecastServiceCall:NO];
    }
    [self.cLLocationManager stopUpdatingLocation];
}

/*
 
 Method Name  : locationManager didChangeAuthorizationStatus
 Parameters   : CLLocationManager instance and status
 Description  : to access location coordinayes
 
 */

- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
        } break;
        case kCLAuthorizationStatusDenied: {
        } break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways: {
            [self.cLLocationManager startUpdatingLocation];
        } break;
        default:
            break;
    }
}


#pragma mark -- Custom Methods
/*
 
 Method Name  : getCurrentWeatherForecastDetails
 Description  : to get weather forecast details for specified location coordinates
 
 */

-(void)getCurrentWeatherForecastDetails
{
    NSURL* url = [self.serviceHandler getNSUrlForParameters:@{kURL:Weather_Forecast_Url,kCoordinates:self.coordinates}];
    [self.serviceHandler responseForURL:url withSuccessHandler:^(NSDictionary *responseDict) {
        if(responseDict)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateUserInterfaceForWeatherForecastServiceCall:NO];
                [self setviewAttributes:[self parseResponse:responseDict]];
        });
        }
    } errorHandler:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Inetenet  appears to be offline");
            [self updateUserInterfaceForWeatherForecastServiceCall:NO];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"NETWORK ERROR" message:@"Please check whether device is connected to network" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        });
    }];
}

/*
 
 Method Name  : parseResponse
 Parameters   : NSDictionary from reponse to websservice
 return parameter : WeatherForecastModel
 Description  : to parse response and convert to model
 
 */

-(WeatherForecastModel*)parseResponse:(NSDictionary*)responseDict
{
    WeatherForecastModel *currWeatherModel = [[WeatherForecastModel alloc]init];
    currWeatherModel.timeZone = responseDict[kTimeZone];
    NSDictionary*currentValuesDict = responseDict[kCurrently];
    currWeatherModel.summary = currentValuesDict[kSummary];
    currWeatherModel.windSpeed = currentValuesDict[kWindSpeed];
    currWeatherModel.humidity = currentValuesDict[kHumidity];
    if(currWeatherModel.summary.length>1)
    {
        [self updateView:currWeatherModel.summary];
    }
    return currWeatherModel;
}

/*
 
 Method Name  : setviewAttributes
 Parameters   : WeatherForecastModel
 Description  : to set view attributes from webservice response
 
 */

-(void)setviewAttributes:(WeatherForecastModel*)weatherForecastModel
{
    self.summaryLabel.text = weatherForecastModel.summary;
    self.windSpeedLabel.text = [NSString stringWithFormat:@"%@",weatherForecastModel.windSpeed];
    self.humidityLabel.text = [NSString stringWithFormat:@"%@",weatherForecastModel.humidity];
    self.timezoneLabel.text = weatherForecastModel.timeZone;
}

/*
 
 Method Name  : updateView
 Parameters   : NSString to change color of view
 Description  : to update view color based on summary received
 
 */

-(void)updateView:(NSString*)summary
{
    if(self.weatherSummaryDictionary[summary])
    {
        [self.view setBackgroundColor:self.weatherSummaryDictionary[summary]];
    }
    else
    {
        [self.view setBackgroundColor:[UIColor greenColor]];
    }
    
}

/*
 
 Method Name  : refreshButtonaction
 Parameters   : id
 Description  : to refresh the location coordinates
 
 */

- (IBAction)refreshButtonaction:(id)sender {

    [self updateUserInterfaceForWeatherForecastServiceCall:YES];
    [self.cLLocationManager startUpdatingLocation];
}

/*
 
 Method Name  : refreshButtonaction
 Parameters   : BOOL to check whether it is service call
 Description  : to update User Interface
 
 */

-(void)updateUserInterfaceForWeatherForecastServiceCall:(BOOL)isServiceCall
{
    if(isServiceCall)
    {
        [self initializeViewAttributes];
        [self.view setBackgroundColor:[UIColor grayColor]];
        self.refreshButton.userInteractionEnabled = NO;
        self.activityIndicator.hidden = NO;
    }else
    {
        self.refreshButton.userInteractionEnabled = YES;
        self.activityIndicator.hidden = YES;
    }
}

/*
 
 Method Name  : summaryLabelText
 Description  : to get summarylabel text for unittest case
 
 */

-(NSString *)summaryLabelText
{
    return self.summaryLabel.text;
}

/*
 
 Method Name  : timezoneLabelText
 Description  : to get timezoneLabel text for unittest case
 
 */

-(NSString *)timezoneLabelText
{
    return self.timezoneLabel.text;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
