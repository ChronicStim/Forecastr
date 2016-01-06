//
//  FCCurrently+Extras.h
//  PainTracker
//
//  Created by Wendy Kutschke on 12/10/15.
//  Copyright © 2015 Chronic Stimulation, LLC. All rights reserved.
//

#import "FCCurrently.h"

typedef enum {
    FPT_PressureFalling = -1,
    FPT_PressureSteady = 0,
    FPT_PressureRising = 1
} ForecastPressureTrend;

@interface FCCurrently (Extras)

-(BOOL)isItDaytime;
-(UIImage *)iconCurrently;
-(NSString *)moonPhaseDescription;
-(NSNumber *)pressureTrend;
-(NSString *)descriptionForPressureTrend:(ForecastPressureTrend)pressureTrend;
-(NSNumber *)humidityAsIntegerNumber;

@end
