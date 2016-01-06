//
//  FCMeasurementPrecipIntensity.m
//  PainTracker
//
//  Created by Wendy Kutschke on 1/6/16.
//  Copyright © 2016 Chronic Stimulation, LLC. All rights reserved.
//

#import "FCMeasurementPrecipIntensity.h"

@implementation FCMeasurementPrecipIntensity

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
                case kFCUnitsModeUK:
                case kFCUnitsModeUS: {
                    // in/hr to in/hr
                    measurementValue = [self.baseValue copy];
                }   break;
                case kFCUnitsModeSI:
                case kFCUnitsModeCA: {
                    // mm/hr to in/hr
                    double convertedValue = [self inchesFromMillimeters:[self.baseValue doubleValue]];
                    measurementValue = [NSNumber numberWithDouble:convertedValue];
                }   break;
                default:
                    break;
            }
        }  break;
            
        case kFCUnitsModeSI:
        case kFCUnitsModeCA: {
            switch (self.baseUnitsMode) {
                case kFCUnitsModeUK:
                case kFCUnitsModeUS: {
                    // in/hr to mm/hr
                    double convertedValue = [self millimetersFromInches:[self.baseValue doubleValue]];
                    measurementValue = [NSNumber numberWithDouble:convertedValue];
                }   break;
                case kFCUnitsModeSI:
                case kFCUnitsModeCA: {
                    // mm/hr to mm/hr
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
            formatString = @"%.0f %@";
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
