//
//  FCCurrently.m
//  PainTracker
//
//  Created by Wendy Kutschke on 12/9/15.
//  Copyright © 2015 Chronic Stimulation, LLC. All rights reserved.
//

#import "FCCurrently.h"

@implementation FCCurrently

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
                                               @"summary" : @"currentSummary",
                                               @"temperature" : @"temperature",
                                               @"visibility" : @"visibility",
                                               @"windBearing" : @"windBearing",
                                               @"windSpeed" : @"windSpeed",
                                               @"nearestStormDistance" : @"nearestStormDistance",
                                               @"nearestStormBearing" : @"nearestStormBearing",
                                               }];
        
        [mapping mapKeyPath:@"time" toProperty:@"fcCurrentlyDate" withValueBlock:^id(NSString *key, id value) {
            return (NSDate *)[NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
        } reverseBlock:^id(id value) {
            return [NSNumber numberWithDouble:[(NSDate *)value timeIntervalSince1970]];
        }];
        
    }];
}

@end
