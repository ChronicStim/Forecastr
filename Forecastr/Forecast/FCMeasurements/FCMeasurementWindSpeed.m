//
//  FCMeasurementWindSpeed.m
//  PainTracker
//
//  Created by Wendy Kutschke on 1/3/16.
//  Copyright © 2016 Chronic Stimulation, LLC. All rights reserved.
//

#import "FCMeasurementWindSpeed.h"

@implementation FCMeasurementWindSpeed

#pragma Data Access Methods

-(NSNumber *)valueWithUnitsMode:(ForecastrUnitsMode)unitsMode;
{
    // Needs to convert the baseValue/baseUnits to the requested unitsMode and return the new value
    NSNumber *measurementValue = nil;
    
    // To be customized for each subclass
    switch (unitsMode) {
        case kFCUnitsModeUS: {
            switch (self.baseUnitsMode) {
                case kFCUnitsModeUS: {
                    // mph to mph
                    measurementValue = [self.baseValue copy];
                }   break;
                case kFCUnitsModeUK: {
                    // mph to mph
                    measurementValue = [self.baseValue copy];
                }   break;
                case kFCUnitsModeSI: {
                    // m/s to mph
                    double convertedValue = [FCMeasurement milesPerHourFromMetersPerSecond:[self.baseValue doubleValue]];
                    measurementValue = [NSNumber numberWithDouble:convertedValue];
                }   break;
                case kFCUnitsModeCA: {
                    // km/hr to mph
                    double convertedValue = [FCMeasurement milesPerHourFromKilometersPerHour:[self.baseValue doubleValue]];
                    measurementValue = [NSNumber numberWithDouble:convertedValue];
                }   break;
                default:
                    break;
            }
        }  break;
            
        case kFCUnitsModeUK: {
            switch (self.baseUnitsMode) {
                case kFCUnitsModeUS: {
                    // mph to mph
                    measurementValue = [self.baseValue copy];
                }   break;
                case kFCUnitsModeUK: {
                    // mph to mph
                    measurementValue = [self.baseValue copy];
                }   break;
                case kFCUnitsModeSI: {
                    // m/s to mph
                    double convertedValue = [FCMeasurement milesPerHourFromMetersPerSecond:[self.baseValue doubleValue]];
                    measurementValue = [NSNumber numberWithDouble:convertedValue];
                }   break;
                case kFCUnitsModeCA: {
                    // km/hr to mph
                    double convertedValue = [FCMeasurement milesPerHourFromKilometersPerHour:[self.baseValue doubleValue]];
                    measurementValue = [NSNumber numberWithDouble:convertedValue];
                }   break;
                default:
                    break;
            }
        }  break;
            
        case kFCUnitsModeSI: {
            switch (self.baseUnitsMode) {
                case kFCUnitsModeUK: {
                    // mph to m/s
                    double convertedValue = [FCMeasurement metersPerSecondFromMilesPerHour:[self.baseValue doubleValue]];
                    measurementValue = [NSNumber numberWithDouble:convertedValue];
                }   break;
                case kFCUnitsModeUS: {
                    // mph to m/s
                    double convertedValue = [FCMeasurement metersPerSecondFromMilesPerHour:[self.baseValue doubleValue]];
                    measurementValue = [NSNumber numberWithDouble:convertedValue];
                }   break;
                case kFCUnitsModeSI: {
                    // m/s to m/s
                    measurementValue = [self.baseValue copy];
                }   break;
                case kFCUnitsModeCA: {
                    // km/hr to m/s
                    double convertedValue = [FCMeasurement metersPerSecondFromKilometersPerHour:[self.baseValue doubleValue]];
                    measurementValue = [NSNumber numberWithDouble:convertedValue];
                }   break;
                default:
                    break;
            }
        }  break;

        case kFCUnitsModeCA: {
            switch (self.baseUnitsMode) {
                case kFCUnitsModeUK: {
                    // mph to km/hr
                    double convertedValue = [FCMeasurement kilometersPerHourFromMilesPerHour:[self.baseValue doubleValue]];
                    measurementValue = [NSNumber numberWithDouble:convertedValue];
                }   break;
                case kFCUnitsModeUS: {
                    // mph to km/hr
                    double convertedValue = [FCMeasurement kilometersPerHourFromMilesPerHour:[self.baseValue doubleValue]];
                    measurementValue = [NSNumber numberWithDouble:convertedValue];
                }   break;
                case kFCUnitsModeSI: {
                    // m/s to km/hr
                    double convertedValue = [FCMeasurement kilometersPerHourFromMetersPerSecond:[self.baseValue doubleValue]];
                    measurementValue = [NSNumber numberWithDouble:convertedValue];
                }   break;
                case kFCUnitsModeCA: {
                    // km/hr to km/hr
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
        case kFCUnitsModeCA:  {
            formatString = @"%.0f %@";
        }   break;
        case kFCUnitsModeSI:  {
            formatString = @"%.1f %@";
        }   break;
        case kFCUnitsModeUS:
        case kFCUnitsModeUK:  {
            formatString = @"%.0f %@";
        }   break;
        case kFCUnitsModeUndefined:
        default:
            break;
    }
    return formatString;
}

@end
