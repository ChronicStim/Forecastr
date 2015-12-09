//
//  FCHourly.m
//  PainTracker
//
//  Created by Wendy Kutschke on 12/9/15.
//  Copyright © 2015 Chronic Stimulation, LLC. All rights reserved.
//

#import "FCHourly.h"

@implementation FCHourly

+(EKObjectMapping *)objectMapping;
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        
        [mapping mapPropertiesFromDictionary:@{
                                               @"apparentTemperature" : @"apparentTemperature",
                                               @"cloudCover" : @"cloudCoverPercentage",
                                               @"dewPoint" : @"dewPoint",
                                               @"humidity" : @"humidity",
                                               @"icon" : @"iconName",
                                               @"ozone" : @"ozone",
                                               @"precipIntensity" : @"precipIntensity",
                                               @"precipProbability" : @"precipProbability",
                                               @"pressure" : @"pressure",
                                               @"summary" : @"hourlySummary",
                                               @"temperature" : @"temperature",
                                               @"visibility" : @"visibility",
                                               @"windBearing" : @"windBearing",
                                               @"windSpeed" : @"windSpeed",
                                               }];
        
        [mapping mapKeyPath:@"time" toProperty:@"fcHourlyDate" withValueBlock:^id(NSString *key, id value) {
            return (NSDate *)[NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
        }];
        
    }];
}

@end
