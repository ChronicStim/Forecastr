//
//  FCFlags.m
//  PainTracker
//
//  Created by Wendy Kutschke on 12/9/15.
//  Copyright © 2015 Chronic Stimulation, LLC. All rights reserved.
//

#import "FCFlags.h"

@implementation FCFlags

+(EKObjectMapping *)objectMapping;
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        
        [mapping mapPropertiesFromDictionary:@{
                                               @"darksky-unavailable" : @"darkskyUnavailable",
                                               @"darksky-stations" : @"darkskyStations",
                                               @"datapoint-stations" : @"datapointStations",
                                               @"isd-stations" : @"isdStations",
                                               @"lamp-stations" : @"lampStations",
                                               @"metar-stations" : @"metarStations",
                                               @"metno-stations" : @"metnoStations",
                                               @"madis-stations" : @"madisStations",
                                               @"sources" : @"sources",
                                               @"units" : @"units"
                                               }];
        
    }];
}

@end
