//
//  FCHourly.m
//  PainTracker
//
//  Created by Wendy Kutschke on 12/9/15.
//  Copyright © 2015 Chronic Stimulation, LLC. All rights reserved.
//

#import "FCHourly.h"
#import "FCFlags.h"

@implementation FCHourly

+(EKObjectMapping *)objectMapping;
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        
        [mapping mapPropertiesFromDictionary:@{
                                               @"cloudCover" : @"cloudCoverPercentage",
                                               @"humidity" : @"humidity",
                                               @"icon" : @"iconName",
                                               @"ozone" : @"ozone",
                                               @"precipProbability" : @"precipProbability",
                                               @"precipType" : @"precipType",
                                               @"summary" : @"hourlySummary",
                                               @"windBearing" : @"windBearing",
                                               }];
        
        [mapping mapKeyPath:@"time" toProperty:@"fcHourlyDate" withValueBlock:^id(NSString *key, id value) {
            // If object is not present in JSON, don't create
            if (nil == value) return nil;
            
            return (NSDate *)[NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
        }];
        
        ForecastrUnitsMode unitsMode = [FCFlags forecastrUnitsModeForUnitsModeString:[[Forecastr sharedManager] units]];
        
        [mapping mapKeyPath:@"apparentTemperature" toProperty:@"apparentTemperature" withValueBlock:^id(NSString *key, id value) {
            // If object is not present in JSON, don't create
            if (nil == value) return nil;
            
            FCMeasurementTemperature *newItem = [[FCMeasurementTemperature alloc] initMeasurement:@"temperature" baseValue:[NSNumber numberWithDouble:[value doubleValue]] baseUnitsMode:unitsMode];
            return newItem;
        }];
        
        [mapping mapKeyPath:@"temperature" toProperty:@"temperature" withValueBlock:^id(NSString *key, id value) {
            // If object is not present in JSON, don't create
            if (nil == value) return nil;
            
            FCMeasurementTemperature *newItem = [[FCMeasurementTemperature alloc] initMeasurement:@"temperature" baseValue:[NSNumber numberWithDouble:[value doubleValue]] baseUnitsMode:unitsMode];
            return newItem;
        }];
        
        [mapping mapKeyPath:@"dewPoint" toProperty:@"dewPoint" withValueBlock:^id(NSString *key, id value) {
            // If object is not present in JSON, don't create
            if (nil == value) return nil;
            
            FCMeasurementTemperature *newItem = [[FCMeasurementTemperature alloc] initMeasurement:@"temperature" baseValue:[NSNumber numberWithDouble:[value doubleValue]] baseUnitsMode:unitsMode];
            return newItem;
        }];
        
        [mapping mapKeyPath:@"precipIntensity" toProperty:@"precipIntensity" withValueBlock:^id(NSString *key, id value) {
            // If object is not present in JSON, don't create
            if (nil == value) return nil;
            
            FCMeasurementPrecipIntensity *newItem = [[FCMeasurementPrecipIntensity alloc] initMeasurement:@"precipIntensity" baseValue:[NSNumber numberWithDouble:[value doubleValue]] baseUnitsMode:unitsMode];
            return newItem;
        }];
        
        [mapping mapKeyPath:@"precipAccumulation" toProperty:@"precipAccumulation" withValueBlock:^id(NSString *key, id value) {
            // If object is not present in JSON, don't create
            if (nil == value) return nil;

            FCMeasurementPrecipAccumulation *newItem = [[FCMeasurementPrecipAccumulation alloc] initMeasurement:@"precipAccumulation" baseValue:[NSNumber numberWithDouble:[value doubleValue]] baseUnitsMode:unitsMode];
            return newItem;
        }];
        
        [mapping mapKeyPath:@"pressure" toProperty:@"pressure" withValueBlock:^id(NSString *key, id value) {
            // If object is not present in JSON, don't create
            if (nil == value) return nil;
            
            FCMeasurementPressure *newItem = [[FCMeasurementPressure alloc] initMeasurement:@"pressure" baseValue:[NSNumber numberWithDouble:[value doubleValue]] baseUnitsMode:unitsMode];
            return newItem;
        }];
        
        [mapping mapKeyPath:@"visibility" toProperty:@"visibility" withValueBlock:^id(NSString *key, id value) {
            // If object is not present in JSON, don't create
            if (nil == value) return nil;
            
            FCMeasurementDistance *newItem = [[FCMeasurementDistance alloc] initMeasurement:@"visibility" baseValue:[NSNumber numberWithDouble:[value doubleValue]] baseUnitsMode:unitsMode];
            return newItem;
        }];
        
        [mapping mapKeyPath:@"windSpeed" toProperty:@"windSpeed" withValueBlock:^id(NSString *key, id value) {
            // If object is not present in JSON, don't create
            if (nil == value) return nil;
            
            FCMeasurementWindSpeed *newItem = [[FCMeasurementWindSpeed alloc] initMeasurement:@"windSpeed" baseValue:[NSNumber numberWithDouble:[value doubleValue]] baseUnitsMode:unitsMode];
            return newItem;
        }];
        
    }];
}

@end
