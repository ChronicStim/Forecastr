//
//  FCFlags.m
//  PainTracker
//
//  Created by Wendy Kutschke on 12/9/15.
//  Copyright © 2015 Chronic Stimulation, LLC. All rights reserved.
//

#import "FCFlags.h"

@interface FCFlags ()


@end


@implementation FCFlags

+(EKObjectMapping *)objectMapping;
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        
        [mapping mapPropertiesFromDictionary:@{
                                               @"darksky-unavailable" : @"darkskyUnavailable",
                                               @"darksky-stations" : @"darkskyStations",
                                               @"datapoint-stations" : @"datapointStations",
                                               @"isd-stations" : @"isdStations",
                                               @"lamp-stations" : @"lampStations",
                                               @"metar-stations" : @"metarStations",
                                               @"metno-stations" : @"metnoStations",
                                               @"madis-stations" : @"madisStations",
                                               @"sources" : @"sources",
                                               @"units" : @"units"
                                               }];
    }];
}

+(ForecastrUnitsMode)forecastrUnitsModeForUnitsModeString:(NSString *)unitsModeString;
{
    ForecastrUnitsMode unitsMode = kFCUnitsModeUndefined;
    
    if ([unitsModeString isEqualToString:kFCUSUnits]) {
        unitsMode = kFCUnitsModeUS;
    }
    else if ([unitsModeString isEqualToString:kFCSIUnits]) {
        unitsMode = kFCUnitsModeSI;
    }
    else if ([unitsModeString isEqualToString:kFCUKUnits]) {
        unitsMode = kFCUnitsModeUK;
    }
    else if ([unitsModeString isEqualToString:kFCCAUnits]) {
        unitsMode = kFCUnitsModeCA;
    }
    return unitsMode;
}

+(NSString *)unitsModeStringForUnitsMode:(ForecastrUnitsMode)unitsMode;
{
    NSString *unitsModeString = @"";
    switch (unitsMode) {
        case kFCUnitsModeUS:
            unitsModeString = kFCUSUnits;
            break;
        case kFCUnitsModeSI:
            unitsModeString = kFCSIUnits;
            break;
        case kFCUnitsModeUK:
            unitsModeString = kFCUKUnits;
            break;
        case kFCUnitsModeCA:
            unitsModeString = kFCCAUnits;
            break;
        default:
            break;
    }
    return unitsModeString;
}

#pragma mark -

-(ForecastrUnitsMode)forecastrUnitsMode;
{
    return [FCFlags forecastrUnitsModeForUnitsModeString:self.units];
}

@end
