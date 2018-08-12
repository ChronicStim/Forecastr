//
//  FCHourly.h
//  PainTracker
//
//  Created by Wendy Kutschke on 12/9/15.
//  Copyright © 2015 Chronic Stimulation, LLC. All rights reserved.
//

#import "FCForecastModel.h"
#import <EasyMapping/EasyMapping.h>

@class FCForecast, FCMeasurementTemperature, FCMeasurementWindSpeed, FCMeasurementDistance, FCMeasurementPressure, FCMeasurementPrecipIntensity, FCMeasurementPrecipAccumulation;
@interface FCHourly : FCForecastModel <EKMappingProtocol>

@property (nonatomic, strong) FCMeasurementTemperature* apparentTemperature;
@property (nonatomic, strong) NSNumber* cloudCoverPercentage;
@property (nonatomic, strong) FCMeasurementTemperature* dewPoint;
@property (nonatomic, strong) NSNumber* humidity;
@property (nonatomic, copy) NSString* iconName;
@property (nonatomic, strong) NSNumber* ozone;
@property (nonatomic, strong) FCMeasurementPrecipIntensity* precipIntensity;
@property (nonatomic, strong) FCMeasurementPrecipAccumulation* precipAccumulation;
@property (nonatomic, strong) NSNumber* precipProbability;
@property (nonatomic, copy) NSString* precipType;
@property (nonatomic, strong) FCMeasurementPressure* pressure;
@property (nonatomic, copy) NSString* hourlySummary;
@property (nonatomic, strong) FCMeasurementTemperature* temperature;
@property (nonatomic, strong) NSDate* fcHourlyDate;
@property (nonatomic, strong) FCMeasurementDistance* visibility;
@property (nonatomic, strong) NSNumber* windBearing;
@property (nonatomic, strong) FCMeasurementWindSpeed* windSpeed;
@property (nonatomic, weak) FCForecast *forecast;

@end
