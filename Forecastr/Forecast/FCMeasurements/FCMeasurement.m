//
//  FCMeasurement.m
//  PainTracker
//
//  Created by Wendy Kutschke on 1/2/16.
//  Copyright © 2016 Chronic Stimulation, LLC. All rights reserved.
//

#import "FCMeasurement.h"
#import "FCFlags.h"

@interface FCMeasurement ()

@property (nonatomic, readwrite, strong) NSNumber *baseValue;
@property (nonatomic, readwrite, assign) ForecastrUnitsMode baseUnitsMode;
@property (nonatomic, readwrite, copy) NSString *measurementKeyName;

@end

@implementation FCMeasurement
@synthesize measurementKeyName = _measurementKeyName;
@synthesize baseValue = _baseValue;
@synthesize baseUnitsMode = _baseUnitsMode;

-(instancetype)initMeasurement:(NSString *)measurementName baseValue:(NSNumber *)baseValue baseUnitsMode:(ForecastrUnitsMode)baseUnitsMode;
{
    self = [super init];
    if (self) {
        _measurementKeyName = [measurementName copy];
        _baseValue = baseValue;
        _baseUnitsMode = baseUnitsMode;
    }
    
    return self;
}

-(id)copyWithZone:(NSZone *)zone;
{
    FCMeasurement *newMeasurement = [[FCMeasurement alloc] initMeasurement:self.measurementKeyName baseValue:self.baseValue baseUnitsMode:self.baseUnitsMode];
    
    return newMeasurement;
}

-(id)mutableCopyWithZone:(NSZone *)zone;
{
    FCMeasurement *newMeasurement = [[FCMeasurement alloc] initMeasurement:self.measurementKeyName baseValue:self.baseValue baseUnitsMode:self.baseUnitsMode];
    
    return newMeasurement;
}

-(NSString *)description;
{
    return [NSString stringWithFormat:@"Measurement: %@ value: %@ units: %@",self.measurementKeyName,self.baseValue,[FCFlags unitsModeStringForUnitsMode:self.baseUnitsMode]];
}

#pragma mark - Display Methods

-(NSString *)suffixStringForUnitsMode:(ForecastrUnitsMode)unitsMode;
{
    NSString *suffixString = nil;
    
    NSDictionary *suffixDict = [self suffixStringMappingDictionary];
    if (nil == suffixDict) {
        return @"";
    }
    
    NSString *unitsKey = [FCFlags unitsModeStringForUnitsMode:unitsMode];
    
    // Locate an entry for this measurement item
    NSDictionary *itemDict = [suffixDict objectForKey:self.measurementKeyName];
    if (nil != itemDict) {
        
        // Now see if an entry exists for the specific units key
        suffixString = [itemDict objectForKey:unitsKey];
        
        if (nil == suffixString) {
            // if a suffix wasn't found, it may be that we're using one of the unitModes that only specifies exceptions (eg. UK & CA modes), so we need to fall back to the default for that mode and try again.
            if ([unitsKey isEqualToString:kFCUKUnits]) {
                unitsKey = kFCUSUnits;
            }
            else if ([unitsKey isEqualToString:kFCCAUnits]) {
                unitsKey = kFCSIUnits;
            }
            
            suffixString = [itemDict objectForKey:unitsKey];
        }
    }
    
    if (nil == suffixString) {
        suffixString = @"";
    }
    return suffixString;
}

-(NSDictionary *)suffixStringMappingDictionary {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ForecastrUnits" ofType:@"plist"];
    NSDictionary *mappingDict = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    return mappingDict;
}

#pragma Data Access Methods

-(NSNumber *)valueWithUnitsMode:(ForecastrUnitsMode)unitsMode;
{
    // Needs to convert the baseValue/baseUnits to the requested unitsMode and return the new value
    NSNumber *measurementValue = nil;

    // To be customized for each subclass (eg shown is for Temp conversion)
    switch (unitsMode) {
        case kFCUnitsModeUS: {
            switch (self.baseUnitsMode) {
                case kFCUnitsModeUS: {
                    // F to F
                    measurementValue = [self.baseValue copy];
                }   break;
                case kFCUnitsModeUK:
                case kFCUnitsModeSI:
                case kFCUnitsModeCA: {
                    // C to F
                    measurementValue = [NSNumber numberWithFloat:[FCMeasurement degreesFahrenheitFromCelsius:[self.baseValue floatValue]]];
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
                    // F to C
                    measurementValue = [NSNumber numberWithFloat:[FCMeasurement degreesCelsiusFromFahrenheit:[self.baseValue floatValue]]];
                }   break;
                case kFCUnitsModeUK:
                case kFCUnitsModeSI:
                case kFCUnitsModeCA: {
                    // C to C
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

-(NSString *)displayStringWithUnitsMode:(ForecastrUnitsMode)unitsMode;
{
    NSString *formatString = [self formatStringWithUnitsMode:unitsMode];
    NSString *suffixString = [self suffixStringForUnitsMode:unitsMode];
    NSNumber *measurement = [self valueWithUnitsMode:unitsMode];
    double measurementDouble = [measurement doubleValue];
    
    return [NSString stringWithFormat:formatString,measurementDouble,suffixString];
}

-(NSString *)formatStringWithUnitsMode:(ForecastrUnitsMode)unitsMode;
{
    // To be defined by subclass
    NSString *formatString = nil;
    
    switch (unitsMode) {
        case kFCUnitsModeUndefined:
        case kFCUnitsModeUS:
        case kFCUnitsModeCA:
        case kFCUnitsModeSI:
        case kFCUnitsModeUK:  {
            formatString = @"%.1f %@";
        }   break;
        default:
            break;
    }
    
    return formatString;
}

#pragma Object Specific Conversion Methods

#pragma mark - Temperature

+(double)degreesFahrenheitFromCelsius:(double)c;
{
    return ((c * 9.0f / 5.0f) + 32.0f);
}

+(double)degreesCelsiusFromFahrenheit:(double)f;
{
    return ((f -32.0f) * 5.0f / 9.0f);
}

#pragma mark - Distance

+(double)milesFromKilometers:(double)km;
{
    return (km * 0.621371f);
}

+(double)kilometersFromMiles:(double)miles;
{
    return (miles * 1.60934f);
}

+(double)millimetersFromInches:(double)inches;
{
    return (inches * 25.4f);
}

+(double)inchesFromMillimeters:(double)mm;
{
    return (mm / 25.4f);
}

+(double)centimetersFromInches:(double)inches;
{
    return ((inches * 25.4f) / 10.0f);
}

+(double)inchesFromCentimeters:(double)cm;
{
    return ((cm * 10.0f) / 25.4f);
}

#pragma mark - Pressure

+(double)milliBarsFromHectoPascal:(double)hPa;
{
    return (hPa * 1.0f);
}

+(double)hectoPascalFromMilliBar:(double)mb;
{
    return (mb * 1.0f);
}

+(double)inchesHgFromMilliBar:(double)mb;
{
    return (mb * 0.02952998751f);
}

+(double)milliBarsFromInchesHg:(double)inHg;
{
    return (inHg / 0.02952998751f);
}

#pragma mark - Speed

+(double)milesPerHourFromMetersPerSecond:(double)metersPerSec;
{
    return ([FCMeasurement milesFromKilometers:(metersPerSec / 1000.0f)] * 3600.0f);
}

+(double)metersPerSecondFromMilesPerHour:(double)mph;
{
    return (([FCMeasurement kilometersFromMiles:mph] * 1000.0f) / 3600.0f);
}

+(double)kilometersPerHourFromMilesPerHour:(double)mph;
{
    return [FCMeasurement kilometersFromMiles:mph];
}

+(double)milesPerHourFromKilometersPerHour:(double)kph;
{
    return [FCMeasurement milesFromKilometers:kph];
}

+(double)kilometersPerHourFromMetersPerSecond:(double)metersPerSec;
{
    return ((metersPerSec * 3600.0f) / 1000.0f);
}

+(double)metersPerSecondFromKilometersPerHour:(double)kph;
{
    return ((kph * 1000.0f) / 3600.0f);
}

#pragma mark - Direction

+(NSString *)cardinalDirectionFromCompassDegrees:(double)degrees;
{
    static NSString *const Directions[] = {
        @"N", @"NNE",  @"NE", @"ENE", @"E", @"ESE", @"SE", @"SSE",
        @"S", @"SSW", @"SW", @"WSW", @"W", @"WNW", @"NW", @"NNW"
    };
    static const int DirectionsCount = sizeof Directions / sizeof *Directions;
    
    int wind = remainder(round((degrees / 360) * DirectionsCount), DirectionsCount);
    if (wind < 0) wind += DirectionsCount;
    return Directions[wind];
}

@end
