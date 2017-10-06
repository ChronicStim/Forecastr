//
//  FCAlert.h
//  PainTracker
//
//  Created by Wendy Kutschke on 12/9/15.
//  Copyright © 2015 Chronic Stimulation, LLC. All rights reserved.
//

#import "FCForecastModel.h"
#import <EasyMapping/EasyMapping.h>

@class FCForecast;
@interface FCAlert : FCForecastModel <EKMappingProtocol>

@property (nonatomic, copy) NSString *alertDescription;
@property (nonatomic, strong) NSDate *expires;
@property (nonatomic, strong) NSDate *fcAlertDate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, weak) FCForecast *forecast;

@end
