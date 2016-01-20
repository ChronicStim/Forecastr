//
//  FCMeasurementDistance.m
//  PainTracker
//
//  Created by Wendy Kutschke on 1/3/16.
//  Copyright © 2016 Chronic Stimulation, LLC. All rights reserved.
//

#import "FCMeasurementDistance.h"

@implementation FCMeasurementDistance

#pragma Data Access Methods

-(NSNumber *)valueWithUnitsMode:(ForecastrUnitsMode)unitsMode;
{
    // Needs to convert the baseValue/baseUnits to the requested unitsMode and return the new value
    NSNumber *measurementValue = nil;
    
    // To be customized for each subclass
    switch (unitsMode) {
        case kFCUnitsModeUS:
        case kFCUnitsModeUK: {
            switch (self.baseUnitsMode) {
                case kFCUnitsModeUS: {
                    // miles to miles
                    measurementValue = [self.baseValue copy];
                }   break;
                case kFCUnitsModeUK: {
                    // miles to miles
                    measurementValue = [self.baseValue copy];
                }   break;
                case kFCUnitsModeSI:
                case kFCUnitsModeCA: {
                    // km to miles
                    double convertedValue = [FCMeasurement milesFromKilometers:[self.baseValue doubleValue]];
                    measurementValue = [NSNumber numberWithDouble:convertedValue];
                }   break;
                default:
                    break;
            }
        }  break;
            
        case kFCUnitsModeSI:
        case kFCUnitsModeCA: {
            switch (self.baseUnitsMode) {
                case kFCUnitsModeUK: {
                    // miles to km
                    double convertedValue = [FCMeasurement kilometersFromMiles:[self.baseValue doubleValue]];
                    measurementValue = [NSNumber numberWithDouble:convertedValue];
                }   break;
                case kFCUnitsModeUS: {
                    // miles to km
                    double convertedValue = [FCMeasurement kilometersFromMiles:[self.baseValue doubleValue]];
                    measurementValue = [NSNumber numberWithDouble:convertedValue];
                }   break;
                case kFCUnitsModeSI:
                case kFCUnitsModeCA: {
                    // km to km
                    measurementValue = [self.baseValue copy];
                }   break;
                default:
                    break;
            }
        }  break;
            
        default:
            break;
    }
    return measurementValue;
}

-(NSString *)formatStringWithUnitsMode:(ForecastrUnitsMode)unitsMode;
{
    // To be defined by subclass
    NSString *formatString = nil;
    
    switch (unitsMode) {
        case kFCUnitsModeCA:
        case kFCUnitsModeSI:  {
            formatString = @"%.1f %@";
        }   break;
        case kFCUnitsModeUS:
        case kFCUnitsModeUK:  {
            formatString = @"%.1f %@";
        }   break;
        case kFCUnitsModeUndefined:
        default:
            break;
    }
    return formatString;
}

@end
