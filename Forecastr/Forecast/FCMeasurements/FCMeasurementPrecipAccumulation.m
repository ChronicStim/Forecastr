//
//  FCMeasurementPrecipAccumulation.m
//  PainTracker
//
//  Created by Wendy Kutschke on 1/6/16.
//  Copyright © 2016 Chronic Stimulation, LLC. All rights reserved.
//

#import "FCMeasurementPrecipAccumulation.h"

@implementation FCMeasurementPrecipAccumulation

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
                    // in to in
                    measurementValue = [self.baseValue copy];
                }   break;
                case kFCUnitsModeUK:
                case kFCUnitsModeSI:
                case kFCUnitsModeCA: {
                    // cm to in
                    double convertedValue = [FCMeasurement inchesFromCentimeters:[self.baseValue doubleValue]];
                    measurementValue = [NSNumber numberWithDouble:convertedValue];
                }   break;
                default:
                    break;
            }
        }  break;
            
        case kFCUnitsModeUK:
        case kFCUnitsModeSI:
        case kFCUnitsModeCA: {
            switch (self.baseUnitsMode) {
                case kFCUnitsModeUS: {
                    // in to cm
                    double convertedValue = [FCMeasurement centimetersFromInches:[self.baseValue doubleValue]];
                    measurementValue = [NSNumber numberWithDouble:convertedValue];
                }   break;
                case kFCUnitsModeUK:
                case kFCUnitsModeSI:
                case kFCUnitsModeCA: {
                    // cm to cm
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
