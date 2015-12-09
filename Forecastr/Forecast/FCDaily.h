//
//  FCDaily.h
//  PainTracker
//
//  Created by Wendy Kutschke on 12/9/15.
//  Copyright © 2015 Chronic Stimulation, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EasyMapping.h"

@interface FCDaily : NSObject <EKMappingProtocol>

@property (nonatomic, strong) NSNumber* apparentTemperatureMax;
@property (nonatomic, strong) NSDate* apparentTemperatureMaxTime;
@property (nonatomic, strong) NSNumber* apparentTemperatureMin;
@property (nonatomic, strong) NSDate* apparentTemperatureMinTime;
@property (nonatomic, strong) NSNumber* cloudCoverPercentage;
@property (nonatomic, strong) NSNumber* dewPoint;
@property (nonatomic, strong) NSNumber* humidity;
@property (nonatomic, copy) NSString* iconName;
@property (nonatomic, strong) NSNumber* moonPhase;
@property (nonatomic, strong) NSNumber* ozone;
@property (nonatomic, strong) NSNumber* precipIntensity;
@property (nonatomic, strong) NSNumber* precipIntensityMax;
@property (nonatomic, strong) NSDate* precipIntensityMaxTime;
@property (nonatomic, strong) NSNumber* precipProbability;
@property (nonatomic, copy) NSString* precipType;
@property (nonatomic, strong) NSNumber* pressure;
@property (nonatomic, copy) NSString* dailySummary;
@property (nonatomic, strong) NSDate* sunriseTime;
@property (nonatomic, strong) NSDate* sunsetTime;
@property (nonatomic, strong) NSNumber* dailyTemperatureMin;
@property (nonatomic, strong) NSDate* dailyTemperatureMinTime;
@property (nonatomic, strong) NSNumber* dailyTemperatureMax;
@property (nonatomic, strong) NSDate* dailyTemperatureMaxTime;
@property (nonatomic, strong) NSDate* fcDailyDate;
@property (nonatomic, strong) NSNumber* visibility;
@property (nonatomic, strong) NSNumber* windBearing;
@property (nonatomic, strong) NSNumber* windSpeed;

@end
