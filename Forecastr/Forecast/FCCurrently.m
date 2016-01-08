//
//  FCCurrently.m
//  PainTracker
//
//  Created by Wendy Kutschke on 12/9/15.
//  Copyright © 2015 Chronic Stimulation, LLC. All rights reserved.
//

#import "FCCurrently.h"
#import "FCForecastModel.h"
#import "Forecastr+Icons.h"

@implementation FCCurrently

+(EKObjectMapping *)objectMapping;
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        
        [mapping mapPropertiesFromDictionary:@{
                                               @"cloudCover" : @"cloudCoverPercentage",
                                               @"humidity" : @"humidity",
                                               @"icon" : @"iconName",
                                               @"ozone" : @"ozone",
                                               @"precipProbability" : @"precipProbability",
                                               @"summary" : @"currentSummary",
                                               @"windBearing" : @"windBearing",
                                               @"nearestStormBearing" : @"nearestStormBearing",
                                               }];
        
        [mapping mapKeyPath:@"time" toProperty:@"fcCurrentlyDate" withValueBlock:^id(NSString *key, id value) {
            return (NSDate *)[NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
        } reverseBlock:^id(id value) {
            return [NSNumber numberWithDouble:[(NSDate *)value timeIntervalSince1970]];
        }];
        
        ForecastrUnitsMode unitsMode = [FCFlags forecastrUnitsModeForUnitsModeString:[[Forecastr sharedManager] units]];
        
        [mapping mapKeyPath:@"apparentTemperature" toProperty:@"apparentTemperature" withValueBlock:^id(NSString *key, id value) {
            FCMeasurementTemperature *newItem = [[FCMeasurementTemperature alloc] initMeasurement:@"temperature" baseValue:[NSNumber numberWithDouble:[value doubleValue]] baseUnitsMode:unitsMode];
            return newItem;
        }];

        [mapping mapKeyPath:@"temperature" toProperty:@"temperature" withValueBlock:^id(NSString *key, id value) {
            FCMeasurementTemperature *newItem = [[FCMeasurementTemperature alloc] initMeasurement:@"temperature" baseValue:[NSNumber numberWithDouble:[value doubleValue]] baseUnitsMode:unitsMode];
            return newItem;
        }];
        
        [mapping mapKeyPath:@"dewPoint" toProperty:@"dewPoint" withValueBlock:^id(NSString *key, id value) {
            FCMeasurementTemperature *newItem = [[FCMeasurementTemperature alloc] initMeasurement:@"temperature" baseValue:[NSNumber numberWithDouble:[value doubleValue]] baseUnitsMode:unitsMode];
            return newItem;
        }];

        [mapping mapKeyPath:@"windSpeed" toProperty:@"windSpeed" withValueBlock:^id(NSString *key, id value) {
            FCMeasurementWindSpeed *newItem = [[FCMeasurementWindSpeed alloc] initMeasurement:@"windSpeed" baseValue:[NSNumber numberWithDouble:[value doubleValue]] baseUnitsMode:unitsMode];
            return newItem;
        }];

        [mapping mapKeyPath:@"visibility" toProperty:@"visibility" withValueBlock:^id(NSString *key, id value) {
            FCMeasurementDistance *newItem = [[FCMeasurementDistance alloc] initMeasurement:@"visibility" baseValue:[NSNumber numberWithDouble:[value doubleValue]] baseUnitsMode:unitsMode];
            return newItem;
        }];
        
        [mapping mapKeyPath:@"nearestStormDistance" toProperty:@"nearestStormDistance" withValueBlock:^id(NSString *key, id value) {
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
        
    }];
}

@end
