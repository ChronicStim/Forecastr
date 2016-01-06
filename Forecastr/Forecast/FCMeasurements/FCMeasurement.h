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

-(double)degreesFahrenheitFromCelsius:(double)c;
-(double)degreesCelsiusFromFahrenheit:(double)f;
-(double)milesFromKilometers:(double)km;
-(double)kilometersFromMiles:(double)miles;
-(double)milliBarsFromHectoPascal:(double)hPa;
-(double)hectoPascalFromMilliBar:(double)mb;
-(double)millimetersFromInches:(double)inches;
-(double)inchesFromMillimeters:(double)mm;

@end
