//
//  FCForecast.m
//  PainTracker
//
//  Created by Wendy Kutschke on 12/9/15.
//  Copyright © 2015 Chronic Stimulation, LLC. All rights reserved.
//

#import "FCForecast.h"
#import "Forecastr+CLLocation.h"
#import "FCForecastModel.h"

@implementation FCForecast

+(EKObjectMapping *)objectMapping;
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        
        [mapping mapPropertiesFromDictionary:@{
                                               @"latitude" : @"latitude",
                                               @"longitude" : @"longitude",
                                               @"offset" : @"offset",
                                               @"timezone" : @"timezone",
                                               @"hourly.icon" : @"iconName",
                                               @"hourly.summary" : @"forecastSummary"
                                               }];
        
        [mapping hasOne:[FCFlags class] forKeyPath:@"flags" forProperty:@"flags"];
        
        [mapping hasOne:[FCCurrently class] forKeyPath:@"currently" forProperty:@"currently"];
        
        [mapping hasMany:[FCAlert class] forKeyPath:@"alerts" forProperty:@"alerts"];
        
        [mapping hasMany:[FCDaily class] forKeyPath:@"daily.data" forProperty:@"dailyForecasts"];
        
        [mapping hasMany:[FCHourly class] forKeyPath:@"hourly.data" forProperty:@"hourlyForecasts"];
        
        [mapping hasMany:[FCMinutely class] forKeyPath:@"minutely.data" forProperty:@"minutelyForecasts"];
        
    }];
}

-(instancetype)init;
{
    self = [super init];
    if (self) {
        
        // Setup KVO monitoring of key properties that effect when FCForecastLocation object needs to be reset
        [self addObserver:self forKeyPath:@"latitude" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:nil];
        [self addObserver:self forKeyPath:@"longitude" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:nil];
    }

    return self;
}

-(NSDate *)fcForecastDate;
{
    if (nil != _fcForecastDate) {
        return _fcForecastDate;
    }
    
    // If the fcForecastDate hasn't been set, default it to the date found in the FCCurrently object (if it exists)
    if (nil != self.currently && nil != self.currently.fcCurrentlyDate) {
        _fcForecastDate = [self.currently.fcCurrentlyDate copy];
    }
    return _fcForecastDate;
}

-(void)dealloc;
{
    [self removeObserver:self forKeyPath:@"latitude"];
    [self removeObserver:self forKeyPath:@"longitude"];
}

#pragma mark - FCForecastLocation methods

-(FCForecastLocation *)forecastLocation;
{
    if (nil != _forecastLocation) {
        return _forecastLocation;
    }

    _forecastLocation = [[FCForecastLocation alloc] initWithLatitude:self.latitude longitude:self.longitude forecast:self];

    return _forecastLocation;
}

-(void)updateForecastLocationWithNewLatitude:(NSNumber *)newLatitude newLongitude:(NSNumber *)newLongitude;
{
    if (nil != newLatitude && nil != newLongitude) {
        // This will update the Lat/Lon coord and will force the forecastLocation object to reverseGeocode the coord to derive a new CLPlacemark
        [self.forecastLocation updateForecastLocationLatitude:newLatitude longitude:newLongitude];
    }
}

#pragma mark - KVO Observing Methods

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context;
{
    NSArray *keyPaths = @[@"latitude",@"longitude"];
    if ([keyPaths containsObject:keyPath]) {
        // Check if the property has changed values. If so, the FCForecastLocation property will need to be updated to ensure incorrect data is not reported.
        id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
        id newValue = [change objectForKey:NSKeyValueChangeNewKey];
        BOOL resetLocation = ![oldValue isEqual:newValue];
        
        if (resetLocation) {
            [self updateForecastLocationWithNewLatitude:self.latitude newLongitude:self.longitude];
        }
    }
}

@end
