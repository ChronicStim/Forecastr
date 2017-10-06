//
//  FCForecastModel.h
//  PainTracker
//
//  Created by Wendy Kutschke on 1/18/16.
//  Copyright © 2016 Chronic Stimulation, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCMeasurement.h"
#import "FCMeasurementTemperature.h"
#import "FCMeasurementWindSpeed.h"
#import "FCMeasurementDistance.h"
#import "FCMeasurementPressure.h"
#import "FCMeasurementPrecipIntensity.h"
#import "FCMeasurementPrecipAccumulation.h"
#import <EasyMapping/EasyMapping.h>
#import <CoreLocation/CoreLocation.h>

@interface FCForecastModel : NSObject <EKMappingProtocol>

@end
