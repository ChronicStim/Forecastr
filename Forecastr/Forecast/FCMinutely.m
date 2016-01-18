//
//  FCMinutely.m
//  PainTracker
//
//  Created by Wendy Kutschke on 12/9/15.
//  Copyright © 2015 Chronic Stimulation, LLC. All rights reserved.
//

#import "FCMinutely.h"
#import "FCFlags.h"

@implementation FCMinutely

+(EKObjectMapping *)objectMapping;
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        
        [mapping mapPropertiesFromDictionary:@{
                                               @"precipProbability" : @"precipProbability",
                                               @"precipType" : @"precipType"
                                               }];
        
        [mapping mapKeyPath:@"time" toProperty:@"fcMinutelyDate" withValueBlock:^id(NSString *key, id value) {
            return (NSDate *)[NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
        }];
        
        ForecastrUnitsMode unitsMode = [FCFlags forecastrUnitsModeForUnitsModeString:[[Forecastr sharedManager] units]];
        
        [mapping mapKeyPath:@"precipIntensity" toProperty:@"precipIntensity" withValueBlock:^id(NSString *key, id value) {
            // If object is not present in JSON, don't create
            if (nil == value) return nil;
            
            FCMeasurementPrecipIntensity *newItem = [[FCMeasurementPrecipIntensity alloc] initMeasurement:@"precipIntensity" baseValue:[NSNumber numberWithDouble:[value doubleValue]] baseUnitsMode:unitsMode];
            return newItem;
        }];
        
    }];
}

@end
