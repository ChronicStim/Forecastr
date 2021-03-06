//
//  FCMeasurementPressure.m
//  PainTracker
//
//  Created by Wendy Kutschke on 1/6/16.
//  Copyright © 2016 Chronic Stimulation, LLC. All rights reserved.
//

#import "FCMeasurementPressure.h"

@implementation FCMeasurementPressure

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
                    // mb to mb
                    measurementValue = [self.baseValue copy];
                }   break;
                case kFCUnitsModeUK:
                case kFCUnitsModeSI:
                case kFCUnitsModeCA: {
                    // hPa to mb
                    double convertedValue = [FCMeasurement milliBarsFromHectoPascal:[self.baseValue doubleValue]];
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
                    // mb to hPa
                    double convertedValue = [FCMeasurement hectoPascalFromMilliBar:[self.baseValue doubleValue]];
                    measurementValue = [NSNumber numberWithDouble:convertedValue];
                }   break;
                case kFCUnitsModeUK:
                case kFCUnitsModeSI:
                case kFCUnitsModeCA: {
                    // hPa to hPa
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
        case kFCUnitsModeUK:
        case kFCUnitsModeCA:
        case kFCUnitsModeSI:  {
            formatString = @"%.0f %@";
        }   break;
        case kFCUnitsModeUS:  {
            formatString = @"%.0f %@";
        }   break;
        case kFCUnitsModeUndefined:
        default:
            break;
    }
    return formatString;
}

@end
