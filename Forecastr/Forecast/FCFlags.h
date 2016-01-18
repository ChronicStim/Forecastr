//
//  FCFlags.h
//  PainTracker
//
//  Created by Wendy Kutschke on 12/9/15.
//  Copyright © 2015 Chronic Stimulation, LLC. All rights reserved.
//

#import "FCForecastModel.h"
#import "EasyMapping.h"
#import "Forecastr.h"

@class FCForecast;
@interface FCFlags : FCForecastModel <EKMappingProtocol>

@property (nonatomic, strong) id darkskyUnavailable;
@property (nonatomic, strong) NSArray *darkskyStations;
@property (nonatomic, strong) NSArray *datapointStations;
@property (nonatomic, strong) NSArray *isdStations;
@property (nonatomic, strong) NSArray *lampStations;
@property (nonatomic, strong) NSArray *metarStations;
@property (nonatomic, strong) NSArray *metnoStations;
@property (nonatomic, strong) NSArray *madisStations;
@property (nonatomic, strong) NSArray *sources;
@property (nonatomic, copy) NSString *units;
@property (nonatomic, weak) FCForecast *forecast;

-(ForecastrUnitsMode)forecastrUnitsMode;

+(ForecastrUnitsMode)forecastrUnitsModeForUnitsModeString:(NSString *)unitsModeString;
+(NSString *)unitsModeStringForUnitsMode:(ForecastrUnitsMode)unitsMode;

@end
