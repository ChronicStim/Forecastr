    //
//  FCCurrently+Extras.h
//  PainTracker
//
//  Created by Wendy Kutschke on 12/10/15.
//  Copyright © 2015 Chronic Stimulation, LLC. All rights reserved.
//

#import "FCCurrently.h"

typedef enum {
    FPT_PressureUndefined = NSIntegerMin,
    FPT_PressureFallingStrong = -2,
    FPT_PressureFalling = -1,
    FPT_PressureSteady = 0,
    FPT_PressureRising = 1,
    FPT_PressureRisingStrong = 2
} ForecastPressureTrend;

typedef enum {
    FPTHB_08 = 8,
    FPTHB_24 = 24
} ForecastPressureTrendHourBand;

typedef enum {
    FPTM_CPTOriginal = 0,
    FPTM_LongShortTermComparison = 1,
    FPTM_LastThreeHoursFMHModel = 2
} ForecastPressureTrendMethod;

@interface FCCurrently (Extras)

-(BOOL)isItDaytime;
-(UIImage *)iconCurrentlyImage;
-(NSString *)iconCurrentlyFilename;
-(NSString *)moonPhaseDescription;
-(NSNumber *)pressureTrend;
-(NSNumber *)pressureTrendWithMethod:(ForecastPressureTrendMethod)method;
-(NSString *)descriptionForPressureTrend:(ForecastPressureTrend)pressureTrend;
-(NSNumber *)humidityAsIntegerNumber;

@end
