//
//  FCMinutely.h
//  PainTracker
//
//  Created by Wendy Kutschke on 12/9/15.
//  Copyright © 2015 Chronic Stimulation, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EasyMapping.h"

@class FCForecast, FCMeasurementPrecipIntensity;
@interface FCMinutely : NSObject <EKMappingProtocol>

@property (nonatomic, strong) FCMeasurementPrecipIntensity* precipIntensity;
@property (nonatomic, strong) NSNumber* precipProbability;
@property (nonatomic, copy) NSString* precipType;
@property (nonatomic, strong) NSDate* fcMinutelyDate;
@property (nonatomic, weak) FCForecast *forecast;

@end
