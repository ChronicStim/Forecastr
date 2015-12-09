//
//  FCDaily.m
//  PainTracker
//
//  Created by Wendy Kutschke on 12/9/15.
//  Copyright © 2015 Chronic Stimulation, LLC. All rights reserved.
//

#import "FCDaily.h"

@implementation FCDaily

+(EKObjectMapping *)objectMapping;
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        
        [mapping mapPropertiesFromDictionary:@{
                                               @"apparentTemperatureMax" : @"apparentTemperatureMax",
                                               @"apparentTemperatureMin" : @"apparentTemperatureMin",
                                               @"cloudCover" : @"cloudCoverPercentage",
                                               @"dewPoint" : @"dewPoint",
                                               @"humidity" : @"humidity",
                                               @"icon" : @"iconName",
                                               @"moonPhase" : @"moonPhase",
                                               @"ozone" : @"ozone",
                                               @"precipIntensity" : @"precipIntensity",
                                               @"precipIntensityMax" : @"precipIntensityMax",
                                               @"precipProbability" : @"precipProbability",
                                               @"precipType" : @"precipType",
                                               @"pressure" : @"pressure",
                                               @"summary" : @"dailySummary",
                                               @"temperatureMin" : @"dailyTemperatureMin",
                                               @"temperatureMax" : @"dailyTemperatureMax",
                                               @"visibility" : @"visibility",
                                               @"windBearing" : @"windBearing",
                                               @"windSpeed" : @"windSpeed",
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
        
    }];
}

@end
