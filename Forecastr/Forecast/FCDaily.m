//
//  FCDaily.m
//  PainTracker
//
//  Created by Wendy Kutschke on 12/9/15.
//  Copyright © 2015 Chronic Stimulation, LLC. All rights reserved.
//

#import "FCDaily.h"
#import "FCForecastModel.h"

@implementation FCDaily

+(EKObjectMapping *)objectMapping;
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        
        [mapping mapPropertiesFromDictionary:@{
                                               @"cloudCover" : @"cloudCoverPercentage",
                                               @"humidity" : @"humidity",
                                               @"icon" : @"iconName",
                                               @"moonPhase" : @"moonPhase",
                                               @"ozone" : @"ozone",
                                               @"precipProbability" : @"precipProbability",
                                               @"precipType" : @"precipType",
                                               @"summary" : @"dailySummary",
                                               @"windBearing" : @"windBearing",
                                               }];
        
        [mapping mapKeyPath:@"time" toProperty:@"fcDailyDate" withValueBlock:^id(NSString *key, id value) {
            return (NSDate *)[NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
        }];
        
        [mapping mapKeyPath:@"apparentTemperatureMaxTime" toProperty:@"apparentTemperatureMaxTime" withValueBlock:^id(NSString *key, id value) {
            return (NSDate *)[NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
        }];
        
        [mapping mapKeyPath:@"apparentTemperatureMinTime" toProperty:@"apparentTemperatureMinTime" withValueBlock:^id(NSString *key, id value) {
            return (NSDate *)[NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
        }];
        
        [mapping mapKeyPath:@"precipIntensityMaxTime" toProperty:@"precipIntensityMaxTime" withValueBlock:^id(NSString *key, id value) {
            return (NSDate *)[NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
        }];
        
        [mapping mapKeyPath:@"dailyTemperatureMinTime" toProperty:@"dailyTemperatureMinTime" withValueBlock:^id(NSString *key, id value) {
            return (NSDate *)[NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
        }];
        
        [mapping mapKeyPath:@"dailyTemperatureMaxTime" toProperty:@"dailyTemperatureMaxTime" withValueBlock:^id(NSString *key, id value) {
            return (NSDate *)[NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
        }];
        
        [mapping mapKeyPath:@"sunriseTime" toProperty:@"sunriseTime" withValueBlock:^id(NSString *key, id value) {
            return (NSDate *)[NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
        }];
        
        [mapping mapKeyPath:@"sunsetTime" toProperty:@"sunsetTime" withValueBlock:^id(NSString *key, id value) {
            return (NSDate *)[NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
        }];
        
        ForecastrUnitsMode unitsMode = [FCFlags forecastrUnitsModeForUnitsModeString:[[Forecastr sharedManager] units]];
        
        [mapping mapKeyPath:@"apparentTemperatureMax" toProperty:@"apparentTemperatureMax" withValueBlock:^id(NSString *key, id value) {
            FCMeasurementTemperature *newItem = [[FCMeasurementTemperature alloc] initMeasurement:@"temperature" baseValue:[NSNumber numberWithDouble:[value doubleValue]] baseUnitsMode:unitsMode];
            return newItem;
        }];
        
        [mapping mapKeyPath:@"apparentTemperatureMin" toProperty:@"apparentTemperatureMin" withValueBlock:^id(NSString *key, id value) {
            FCMeasurementTemperature *newItem = [[FCMeasurementTemperature alloc] initMeasurement:@"temperature" baseValue:[NSNumber numberWithDouble:[value doubleValue]] baseUnitsMode:unitsMode];
            return newItem;
        }];
        
        [mapping mapKeyPath:@"dewPoint" toProperty:@"dewPoint" withValueBlock:^id(NSString *key, id value) {
            FCMeasurementTemperature *newItem = [[FCMeasurementTemperature alloc] initMeasurement:@"temperature" baseValue:[NSNumber numberWithDouble:[value doubleValue]] baseUnitsMode:unitsMode];
            return newItem;
        }];
        
        [mapping mapKeyPath:@"temperatureMin" toProperty:@"dailyTemperatureMin" withValueBlock:^id(NSString *key, id value) {
            FCMeasurementTemperature *newItem = [[FCMeasurementTemperature alloc] initMeasurement:@"temperature" baseValue:[NSNumber numberWithDouble:[value doubleValue]] baseUnitsMode:unitsMode];
            return newItem;
        }];
        
        [mapping mapKeyPath:@"temperatureMax" toProperty:@"dailyTemperatureMax" withValueBlock:^id(NSString *key, id value) {
            FCMeasurementTemperature *newItem = [[FCMeasurementTemperature alloc] initMeasurement:@"temperature" baseValue:[NSNumber numberWithDouble:[value doubleValue]] baseUnitsMode:unitsMode];
            return newItem;
        }];
        
        [mapping mapKeyPath:@"visibility" toProperty:@"visibility" withValueBlock:^id(NSString *key, id value) {
            FCMeasurementDistance *newItem = [[FCMeasurementDistance alloc] initMeasurement:@"visibility" baseValue:[NSNumber numberWithDouble:[value doubleValue]] baseUnitsMode:unitsMode];
            return newItem;
        }];
        
        [mapping mapKeyPath:@"pressure" toProperty:@"pressure" withValueBlock:^id(NSString *key, id value) {
            FCMeasurementPressure *newItem = [[FCMeasurementPressure alloc] initMeasurement:@"pressure" baseValue:[NSNumber numberWithDouble:[value doubleValue]] baseUnitsMode:unitsMode];
            return newItem;
        }];
        
        [mapping mapKeyPath:@"precipIntensity" toProperty:@"precipIntensity" withValueBlock:^id(NSString *key, id value) {
            FCMeasurementPrecipIntensity *newItem = [[FCMeasurementPrecipIntensity alloc] initMeasurement:@"precipIntensity" baseValue:[NSNumber numberWithDouble:[value doubleValue]] baseUnitsMode:unitsMode];
            return newItem;
        }];
        
        [mapping mapKeyPath:@"precipIntensityMax" toProperty:@"precipIntensityMax" withValueBlock:^id(NSString *key, id value) {
            FCMeasurementPrecipIntensity *newItem = [[FCMeasurementPrecipIntensity alloc] initMeasurement:@"precipIntensity" baseValue:[NSNumber numberWithDouble:[value doubleValue]] baseUnitsMode:unitsMode];
            return newItem;
        }];
        
        [mapping mapKeyPath:@"precipAccumulation" toProperty:@"precipAccumulation" withValueBlock:^id(NSString *key, id value) {
            FCMeasurementPrecipAccumulation *newItem = [[FCMeasurementPrecipAccumulation alloc] initMeasurement:@"precipAccumulation" baseValue:[NSNumber numberWithDouble:[value doubleValue]] baseUnitsMode:unitsMode];
            return newItem;
        }];
        
        [mapping mapKeyPath:@"windSpeed" toProperty:@"windSpeed" withValueBlock:^id(NSString *key, id value) {
            FCMeasurementWindSpeed *newItem = [[FCMeasurementWindSpeed alloc] initMeasurement:@"windSpeed" baseValue:[NSNumber numberWithDouble:[value doubleValue]] baseUnitsMode:unitsMode];
            return newItem;
        }];
        
    }];
}

@end
