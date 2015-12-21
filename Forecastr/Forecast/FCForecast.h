//
//  FCForecast.h
//  PainTracker
//
//  Created by Wendy Kutschke on 12/9/15.
//  Copyright © 2015 Chronic Stimulation, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EasyMapping.h"

@class FCFlags, FCCurrently, FCForecastLocation;
@interface FCForecast : NSObject <EKMappingProtocol>

@property (nonatomic, copy) NSString *jsonResponseString; // Optionally store the JSON response for later use
@property (nonatomic, strong) NSDate* fcForecastDate; // Could either be manually set or default from the value in the FCCurrently object

@property (nonatomic, copy) NSString* languageCode; // Isn't specified in the JSON response, so this needs to be manually set once the object is created.


// All the following properites are automatically mapped from the JSON response
@property (nonatomic, strong) NSNumber* latitude;
@property (nonatomic, strong) NSNumber* longitude;
@property (nonatomic, strong) NSNumber* offset;
@property (nonatomic, copy) NSString* timezone;
@property (nonatomic, strong) FCForecastLocation *forecastLocation;

@property (nonatomic, strong) FCFlags *flags;
@property (nonatomic, strong) NSArray *alerts;

@property (nonatomic, strong) FCCurrently *currently;
@property (nonatomic, strong) NSArray *dailyForecasts;
@property (nonatomic, strong) NSArray *hourlyForecasts;
@property (nonatomic, strong) NSArray *minutelyForecasts;
@property (nonatomic, copy) NSString* iconName; // Comes from the hourly section
@property (nonatomic, copy) NSString* forecastSummary; // Comes from the hourly section


@end
