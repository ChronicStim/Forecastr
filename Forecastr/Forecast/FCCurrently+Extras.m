//
//  FCCurrently+Extras.m
//  PainTracker
//
//  Created by Wendy Kutschke on 12/10/15.
//  Copyright © 2015 Chronic Stimulation, LLC. All rights reserved.
//

#import "FCCurrently+Extras.h"
#import "Forecastr+Icons.h"
#import "FCForecast+Extras.h"
#import "FCDaily+Extras.h"
#import "FCHourly+Extras.h"

#define kFCCurrentlyPressureDataPointHourlyDate @"kFCCurrentlyPressureDataPointHourlyDate"
#define kFCCurrentlyPressureDataPointPressure @"kFCCurrentlyPressureDataPointPressure"
#define kFCCurrentlyPressureDataPointHourIndex @"kFCCurrentlyPressureDataPointHourIndex"
#define kFCCurrentlyPressureDataPointABSHourIndex @"kFCCurrentlyPressureDataPointABSHourIndex"

@implementation FCCurrently (Extras)

-(BOOL)isItDaytime;
{
    BOOL daytime = YES;
    
    FCDaily *daily = [self.forecast.dailyForecasts firstObject];
    if (nil != daily) {
        NSDate *sunrise = daily.sunriseTime;
        NSDate *sunset = daily.sunsetTime;
        NSDate *current = self.fcCurrentlyDate;
        
        if ([current compare:sunrise] == NSOrderedAscending || [current compare:sunset] == NSOrderedDescending) {
            daytime = NO;
        }
    }
    return daytime;
}

-(UIImage *)iconCurrentlyImage;
{
    UIImage *iconImage = nil;
    if (nil != self.iconName) {
        BOOL useDaytimeImage = [self isItDaytime];
        iconImage = [[Forecastr sharedManager] iconImageForIconName:self.iconName daytime:useDaytimeImage imageSize:kForecastrIconsDefaultIconSize scale:0];
    }
    return iconImage;
}

-(NSString *)iconCurrentlyFilename;
{
    NSString *iconFilename = nil;
    if (nil != self.iconName) {
        BOOL useDaytimeImage = [self isItDaytime];
        iconFilename = [[Forecastr sharedManager] refinedIconImageFilenameFromIconName:self.iconName daytime:useDaytimeImage];
    }
    return iconFilename;
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
        // We only want to evaluate the points closest to the hour of fcCurrentDate, so need to reduce the array to the two pressure points just above and below the fcCurrentDate. Can use the hourIndex value (with an ABS() func) to sort the array items and the hourDate as a secondary sort to ensure we keep the right order of data points
        NSSortDescriptor *sortDescriptorABSHourIndex = [[NSSortDescriptor alloc] initWithKey:kFCCurrentlyPressureDataPointABSHourIndex ascending:YES];
        NSSortDescriptor *sortDescriptorHourDate = [[NSSortDescriptor alloc] initWithKey:kFCCurrentlyPressureDataPointHourlyDate ascending:YES];
        NSArray *sortDescriptors = @[sortDescriptorABSHourIndex, sortDescriptorHourDate];
        NSArray *sortedDataPointArray = [dataPointArray sortedArrayUsingDescriptors:sortDescriptors];
        
        if (2 >= [sortedDataPointArray count]) {
            NSLog(@"Not enough data points to determine pressure trend. Available data points = %@",sortedDataPointArray);
            return nil;
        }
        
        // Now take just the first two items. The following are the 3 possible combinations that could arise depending on where in the 24 hour period the fcCurrentDate falls (bc the Hourly data is only supplied for a fixed 24 hour period each day, not +-12 hours from the fcCurrentDate)
        // Examples use {hourIndex, pressureInMillibar}
        // (A) {0, 1023.61}, {1, 1023.3}    fcCurrentDate falls in the first hour block
        // (B) {0, 1023.42}, {0, 1023.61}
        // (C) {-1, 1023.3}, {0, 1023.42}   fcCurrentDate falls in the last hour block
        NSMutableArray *shortTermDataArray = [NSMutableArray new];
        [shortTermDataArray addObject:[sortedDataPointArray objectAtIndex:0]];
        [shortTermDataArray addObject:[sortedDataPointArray objectAtIndex:1]];
        // Sort one more time, this time on hourDate only to ensure that case (c) has the correct data point first.
        [shortTermDataArray sortUsingDescriptors:@[sortDescriptorHourDate]];
        
        // Determine the pressure delta between the two points
        NSDictionary *dataPointZeroDict = [shortTermDataArray objectAtIndex:0];
        NSDictionary *dataPointOneDict = [shortTermDataArray objectAtIndex:1];
        
        FCMeasurementPressure *pressureZero, *pressureOne;
        double pressureZeroMb, pressureOneMb;
        NSDate *hourDateZero, *hourDateOne;
        
        pressureZero = [dataPointZeroDict objectForKey:kFCCurrentlyPressureDataPointPressure];
        pressureOne = [dataPointOneDict objectForKey:kFCCurrentlyPressureDataPointPressure];
        pressureZeroMb = [[pressureZero valueWithUnitsMode:kFCUnitsModeUS] doubleValue];
        pressureOneMb = [[pressureOne valueWithUnitsMode:kFCUnitsModeUS] doubleValue];
        hourDateZero = [dataPointZeroDict objectForKey:kFCCurrentlyPressureDataPointHourlyDate];
        hourDateOne = [dataPointOneDict objectForKey:kFCCurrentlyPressureDataPointHourlyDate];
        
        double pressureDelta = (pressureOneMb - pressureZeroMb);
        double hourDelta = ((float)[hourDateOne timeIntervalSinceDate:hourDateZero] / 3600.0f);
        double pressureChangePerHour = pressureDelta / hourDelta;
        
        NSInteger currentTrendDirection;
        if (-0.5f >= pressureChangePerHour) {
            currentTrendDirection = FPT_PressureFalling;
        }
        else if (0.5f <= pressureChangePerHour) {
            currentTrendDirection = FPT_PressureRising;
        }
        else {
            currentTrendDirection = FPT_PressureSteady;
        }
        
        // Debug info
        NSLog(@"Pressure trend = %li; PressureDeltaPerHour = %.3f; PressureDelta = %.3f; HourDelta = %.3f; DataPointZero = %@; DataPointOne = %@",(long)currentTrendDirection,pressureChangePerHour,pressureDelta,hourDelta,dataPointZeroDict,dataPointOneDict);
        
        return [NSNumber numberWithInteger:currentTrendDirection];
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
        [self.forecast.hourlyForecasts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            FCHourly *hourlyForecast = (FCHourly *)obj;
            NSInteger conditionHour = (NSInteger)floor([hourlyForecast.fcHourlyDate timeIntervalSinceDate:currentForecastDate]/3600.0f);

            FCMeasurementPressure *pressure = [hourlyForecast.pressure copy];
            NSDictionary *pressureDataPointDict = @{kFCCurrentlyPressureDataPointHourlyDate : hourlyForecast.fcHourlyDate,kFCCurrentlyPressureDataPointHourIndex : [NSNumber numberWithInteger:conditionHour],kFCCurrentlyPressureDataPointABSHourIndex : [NSNumber numberWithInteger:abs((int)conditionHour)],kFCCurrentlyPressureDataPointPressure : pressure};

            [dataPointArray addObject:pressureDataPointDict];
        }];
    }
    
    return [NSArray arrayWithArray:dataPointArray];
}

@end
