//
//  FCHourly.h
//  PainTracker
//
//  Created by Wendy Kutschke on 12/9/15.
//  Copyright © 2015 Chronic Stimulation, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EasyMapping.h"

@class FCForecast;
@interface FCHourly : NSObject <EKMappingProtocol>

@property (nonatomic, strong) NSNumber* apparentTemperature;
@property (nonatomic, strong) NSNumber* cloudCoverPercentage;
@property (nonatomic, strong) NSNumber* dewPoint;
@property (nonatomic, strong) NSNumber* humidity;
@property (nonatomic, copy) NSString* iconName;
@property (nonatomic, strong) NSNumber* ozone;
@property (nonatomic, strong) NSNumber* precipIntensity;
@property (nonatomic, strong) NSNumber* precipProbability;
@property (nonatomic, strong) NSNumber* pressure;
@property (nonatomic, copy) NSString* hourlySummary;
@property (nonatomic, strong) NSNumber* temperature;
@property (nonatomic, strong) NSDate* fcHourlyDate;
@property (nonatomic, strong) NSNumber* visibility;
@property (nonatomic, strong) NSNumber* windBearing;
@property (nonatomic, strong) NSNumber* windSpeed;
@property (nonatomic, weak) FCForecast *forecast;

@end
