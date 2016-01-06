//
//  FCCurrently+Extras.m
//  PainTracker
//
//  Created by Wendy Kutschke on 12/10/15.
//  Copyright © 2015 Chronic Stimulation, LLC. All rights reserved.
//

#import "FCCurrently+Extras.h"
#import "Forecastr+Icons.h"
#import "FCForecastModel.h"

@implementation FCCurrently (Extras)


-(BOOL)isItDaytime;
{
    BOOL daytime = YES;
    
    FCDaily *daily = [self.forecast.dailyForecasts firstObject];
    if (nil != daily) {
        NSDate *sunrise = daily.sunriseTime;
        NSDate *sunset = daily.sunsetTime;
        NSDate *current = self.fcCurrentlyDate;
        
        daytime = ((current == [current earlierDate:sunrise]) || (current == [current laterDate:sunset]));
    }
    return daytime;
}

-(UIImage *)iconCurrently;
{
    UIImage *iconImage = nil;
    if (nil != self.iconName) {
        BOOL useDaytimeImage = [self isItDaytime];
        iconImage = [[Forecastr sharedManager] iconImageForIconName:self.iconName daytime:useDaytimeImage imageSize:kForecastrIconsDefaultIconSize];
    }
    return iconImage;
}

-(NSString *)moonPhaseDescription;
{
    NSString *phaseDescription = nil;
    if (nil != self.forecast && nil != [self.forecast.dailyForecasts firstObject]) {
        FCDaily *daily = [self.forecast.dailyForecasts firstObject];
        phaseDescription = [daily moonPhaseDescription];
    }
    return phaseDescription;
}

-(NSNumber *)humidityAsIntegerNumber;
{
    NSNumber *humidity = nil;
    if (nil != self.humidity && (0.0f <= [self.humidity doubleValue] && 1.0f >= [self.humidity doubleValue])) {
        humidity = [NSNumber numberWithDouble:(100.0f * [self.humidity doubleValue])];
    }
    return humidity;
}

#pragma mark - Pressure Trend methods

-(NSNumber *)pressureTrend;
{
    // Create list of pressure data points from hourly forecast data
    NSArray *dataPointArray = [self getArrayOfHourlyPressureDataPoints];
    
    if (nil != dataPointArray) {
        // Reduce dataPointArray to most recent data (+- 1 hr)
        NSPredicate *shortPredicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            NSValue *valuePoint = (NSValue *)evaluatedObject;
            CGPoint dataPoint = [valuePoint CGPointValue];
            if (fabsf(dataPoint.x) > 1) {
                return NO;
            }
            return YES;
        }];
        NSArray *shortTermDataArray = [dataPointArray filteredArrayUsingPredicate:shortPredicate];
        
        // Determine the pressure delta from one point to the next for the one or two data points that are closest to the current forecast time. These will be the ones with the "0" values for the point.x value
        int itemCount = [shortTermDataArray count];
        NSMutableArray __block *pressureDeltaArray = [NSMutableArray new];
        
        NSArray *dataArray = [shortTermDataArray copy];
        [shortTermDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSValue *dataPointValue = (NSValue *)obj;
            CGPoint dataPoint = [dataPointValue CGPointValue];
            double pressureDelta;
            
            // We only want to evaluate the points where x-value is zero (data points within 1 hour of fcCurrentDate)
            if (0 == (int)dataPoint.x) {
                
                if (0 == idx && 0 < itemCount) {
                    // item is first object in multi-item array
                    NSValue *comparisonPointValue = (NSValue *)[dataArray objectAtIndex:(idx + 1)];
                    CGPoint comparisonPoint = [comparisonPointValue CGPointValue];
                    pressureDelta = (comparisonPoint.y - dataPoint.y);
                    [pressureDeltaArray addObject:[NSNumber numberWithDouble:pressureDelta]];
                }
                else if (0 < idx) {
                    // item is any object other than the first object
                    NSValue *comparisonPointValue = (NSValue *)[dataArray objectAtIndex:(idx - 1)];
                    CGPoint comparisonPoint = [comparisonPointValue CGPointValue];
                    pressureDelta = (dataPoint.y - comparisonPoint.y);
                    [pressureDeltaArray addObject:[NSNumber numberWithDouble:pressureDelta]];
                }
                
            }
        }];
        
        if (0 == [pressureDeltaArray count]) {
            return nil;
        }
        
        // The latter value in the pressureDeltaArray will represent the pressure delta for the time period that best corresponds to the current time period. So, we'll take that as the comparison point to determine the trend direction.
        double currentTrend = [[pressureDeltaArray lastObject] doubleValue];
        NSInteger currentTrendDirection;
        if (-0.5f >= currentTrend) {
            currentTrendDirection = FPT_PressureFalling;
        }
        else if (0.5f <= currentTrend) {
            currentTrendDirection = FPT_PressureRising;
        }
        else {
            currentTrendDirection = FPT_PressureSteady;
        }
        
        return [NSNumber numberWithInt:currentTrendDirection];
    }
    
    return nil;
}

-(NSString *)descriptionForPressureTrend:(ForecastPressureTrend)pressureTrend;
{
    NSString *pressureTrendDescription = @"Unavailable";
    switch (pressureTrend) {
        case FPT_PressureFalling:  {
            pressureTrendDescription = NSLocalizedString(@"Falling", @"Falling");
        }   break;
        case FPT_PressureSteady:  {
            pressureTrendDescription = NSLocalizedString(@"Steady", @"Steady");
        }   break;
        case FPT_PressureRising:  {
            pressureTrendDescription = NSLocalizedString(@"Rising", @"Rising");
        }   break;
        default:
            break;
    }
    return pressureTrendDescription;
}

-(NSArray *)getArrayOfHourlyPressureDataPoints;
{
    NSMutableArray __block *dataPointArray = [NSMutableArray new];
    
    if (self.forecast && self.forecast.hourlyForecasts) {
        
        NSDate *currentForecastDate = [self.fcCurrentlyDate copy];
        [self.forecast.hourlyForecasts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            FCHourly *hourlyForecast = (FCHourly *)obj;
            NSInteger conditionHour = (NSInteger)roundf(([hourlyForecast.fcHourlyDate timeIntervalSinceDate:currentForecastDate]/3600.0f));
            // y-value is the barometric pressure
            FCMeasurementPressure *pressure = [hourlyForecast.pressure copy];
            CGPoint dataPoint = CGPointMake((float)conditionHour, [pressure.baseValue doubleValue]);
            [dataPointArray addObject:[NSValue valueWithCGPoint:dataPoint]];
        }];
    }
    
    return [NSArray arrayWithArray:dataPointArray];
}

@end
