//
//  FCForecast+Extras.m
//  PainTracker
//
//  Created by Wendy Kutschke on 12/10/15.
//  Copyright © 2015 Chronic Stimulation, LLC. All rights reserved.
//

#import "FCForecast+Extras.h"
#import "Forecastr+Icons.h"
#import "FCForecastModel.h"

@implementation FCForecast (Extras)


-(void)buildWeakRelationshipsFromChildObjects;
{
    // EasyMapping doesn't seem to have a way to assign a reverse relationship from a child object back to a parent object when NOT using core data objects. These weak links will be helpful when using conveinence methods from those child objects to traverse to other portions of the Forecast model.
    
    FCForecast __weak *weakSelf = self;
    
    for (FCAlert *alert in self.alerts) {
        alert.forecast = weakSelf;
    }
    
    self.currently.forecast = weakSelf;
    self.flags.forecast = weakSelf;
    self.forecastLocation.forecast = weakSelf;
    
    for (FCDaily *daily in self.dailyForecasts) {
        daily.forecast = weakSelf;
    }
    
    for (FCHourly *hourly in self.hourlyForecasts) {
        hourly.forecast = weakSelf;
    }
    
    for (FCMinutely *minutely in self.minutelyForecasts) {
        minutely.forecast = weakSelf;
    }
    
}

-(UIImage *)iconForecast;
{
    UIImage *iconImage = nil;
    if (nil != self.iconName) {
        BOOL useDaytimeImage = [self.currently isItDaytime];
        iconImage = [[Forecastr sharedManager] iconImageForIconName:self.iconName daytime:useDaytimeImage imageSize:kForecastrIconsDefaultIconSize];
    }
    return iconImage;
}

@end
