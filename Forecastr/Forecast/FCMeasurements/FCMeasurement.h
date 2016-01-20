//
//  FCMeasurement.h
//  PainTracker
//
//  Created by Wendy Kutschke on 1/2/16.
//  Copyright © 2016 Chronic Stimulation, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Forecastr.h"

@interface FCMeasurement : NSObject

@property (nonatomic, readonly, strong) NSNumber *baseValue;
@property (nonatomic, readonly, assign) ForecastrUnitsMode baseUnitsMode;
@property (nonatomic, readonly, copy) NSString *measurementKeyName;

-(instancetype)initMeasurement:(NSString *)measurementName baseValue:(NSNumber *)baseValue baseUnitsMode:(ForecastrUnitsMode)baseUnitsMode;
-(NSNumber *)valueWithUnitsMode:(ForecastrUnitsMode)unitsMode;
-(NSString *)displayStringWithUnitsMode:(ForecastrUnitsMode)unitsMode;

// Temperature
+(double)degreesFahrenheitFromCelsius:(double)c;
+(double)degreesCelsiusFromFahrenheit:(double)f;

// Distance
+(double)milesFromKilometers:(double)km;
+(double)kilometersFromMiles:(double)miles;
+(double)millimetersFromInches:(double)inches;
+(double)inchesFromMillimeters:(double)mm;
+(double)centimetersFromInches:(double)inches;
+(double)inchesFromCentimeters:(double)cm;

// Pressure
+(double)milliBarsFromHectoPascal:(double)hPa;
+(double)hectoPascalFromMilliBar:(double)mb;
+(double)inchesHgFromMilliBar:(double)mb;
+(double)milliBarsFromInchesHg:(double)inHg;

// Speed
+(double)milesPerHourFromMetersPerSecond:(double)metersPerSec;
+(double)metersPerSecondFromMilesPerHour:(double)mph;
+(double)kilometersPerHourFromMilesPerHour:(double)mph;
+(double)milesPerHourFromKilometersPerHour:(double)kph;
+(double)kilometersPerHourFromMetersPerSecond:(double)metersPerSec;
+(double)metersPerSecondFromKilometersPerHour:(double)kph;

// Direction
+(NSString *)cardinalDirectionFromCompassDegrees:(double)degrees;

@end
