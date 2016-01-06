//
//  FCDaily.h
//  PainTracker
//
//  Created by Wendy Kutschke on 12/9/15.
//  Copyright © 2015 Chronic Stimulation, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EasyMapping.h"

@class FCForecast, FCMeasurementTemperature, FCMeasurementWindSpeed, FCMeasurementDistance, FCMeasurementPressure, FCMeasurementPrecipIntensity, FCMeasurementPrecipAccumulation;
@interface FCDaily : NSObject <EKMappingProtocol>

@property (nonatomic, strong) FCMeasurementTemperature* apparentTemperatureMax;
@property (nonatomic, strong) NSDate* apparentTemperatureMaxTime;
@property (nonatomic, strong) FCMeasurementTemperature* apparentTemperatureMin;
@property (nonatomic, strong) NSDate* apparentTemperatureMinTime;
@property (nonatomic, strong) NSNumber* cloudCoverPercentage;
@property (nonatomic, strong) FCMeasurementTemperature* dewPoint;
@property (nonatomic, strong) NSNumber* humidity;
@property (nonatomic, copy) NSString* iconName;
@property (nonatomic, strong) NSNumber* moonPhase;
@property (nonatomic, strong) NSNumber* ozone;
@property (nonatomic, strong) FCMeasurementPrecipIntensity* precipIntensity;
@property (nonatomic, strong) FCMeasurementPrecipIntensity* precipIntensityMax;
@property (nonatomic, strong) FCMeasurementPrecipAccumulation* precipAccumulation;
@property (nonatomic, strong) NSDate* precipIntensityMaxTime;
@property (nonatomic, strong) NSNumber* precipProbability;
@property (nonatomic, copy) NSString* precipType;
@property (nonatomic, strong) FCMeasurementPressure* pressure;
@property (nonatomic, copy) NSString* dailySummary;
@property (nonatomic, strong) NSDate* sunriseTime;
@property (nonatomic, strong) NSDate* sunsetTime;
@property (nonatomic, strong) FCMeasurementTemperature* dailyTemperatureMin;
@property (nonatomic, strong) NSDate* dailyTemperatureMinTime;
@property (nonatomic, strong) FCMeasurementTemperature* dailyTemperatureMax;
@property (nonatomic, strong) NSDate* dailyTemperatureMaxTime;
@property (nonatomic, strong) NSDate* fcDailyDate;
@property (nonatomic, strong) FCMeasurementDistance* visibility;
@property (nonatomic, strong) NSNumber* windBearing;
@property (nonatomic, strong) FCMeasurementWindSpeed* windSpeed;
@property (nonatomic, weak) FCForecast *forecast;

@end
