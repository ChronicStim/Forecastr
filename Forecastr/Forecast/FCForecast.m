//
//  FCForecast.m
//  PainTracker
//
//  Created by Wendy Kutschke on 12/9/15.
//  Copyright © 2015 Chronic Stimulation, LLC. All rights reserved.
//

#import "FCForecast.h"
#import "Forecastr+CLLocation.h"

@implementation FCForecast

+(EKObjectMapping *)objectMapping;
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        
        [mapping mapPropertiesFromDictionary:@{
                                               @"latitude" : @"latitude",
                                               @"longitude" : @"longitude",
                                               @"offset" : @"offset",
                                               @"timezone" : @"timezone",
                                               @"hourly.icon" : @"iconName",
                                               @"hourly.summary" : @"forecastSummary"
                                               }];
        
        [mapping hasOne:[FCFlags class] forKeyPath:@"flags" forProperty:@"flags"];
        
        [mapping hasOne:[FCCurrently class] forKeyPath:@"currently" forProperty:@"currently"];
        
        [mapping hasMany:[FCAlert class] forKeyPath:@"alerts" forProperty:@"alerts"];
        
        [mapping hasMany:[FCDaily class] forKeyPath:@"daily.data" forProperty:@"dailyForecasts"];
        
        [mapping hasMany:[FCHourly class] forKeyPath:@"hourly.data" forProperty:@"hourlyForecasts"];
        
        [mapping hasMany:[FCMinutely class] forKeyPath:@"minutely.data" forProperty:@"minutelyForecasts"];
        
    }];
}

-(NSDate *)fcForecastDate;
{
    if (nil != _fcForecastDate) {
        return _fcForecastDate;
    }
    
    // If the fcForecastDate hasn't been set, default it to the date found in the FCCurrently object (if it exists)
    if (nil != self.currently && nil != self.currently.fcCurrentlyDate) {
        _fcForecastDate = [self.currently.fcCurrentlyDate copy];
    }
    return _fcForecastDate;
}

@end
