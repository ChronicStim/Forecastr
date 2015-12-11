//
//  FCCurrently+Extras.m
//  PainTracker
//
//  Created by Wendy Kutschke on 12/10/15.
//  Copyright © 2015 Chronic Stimulation, LLC. All rights reserved.
//

#import "FCCurrently+Extras.h"
#import "Forecastr+Icons.h"
#import "FCForecastModel.h"

@implementation FCCurrently (Extras)


-(BOOL)isItDaytime;
{
    BOOL daytime = YES;
    
    FCDaily *daily = [self.forecast.dailyForecasts firstObject];
    if (nil != daily) {
        NSDate *sunrise = daily.sunriseTime;
        NSDate *sunset = daily.sunsetTime;
        NSDate *current = self.fcCurrentlyDate;
        
        daytime = ((current == [current earlierDate:sunrise]) || (current == [current laterDate:sunset]));
    }
    return daytime;
}

-(UIImage *)iconCurrently;
{
    UIImage *iconImage = nil;
    if (nil != self.iconName) {
        BOOL useDaytimeImage = [self isItDaytime];
        iconImage = [[Forecastr sharedManager] iconImageForIconName:self.iconName daytime:useDaytimeImage imageSize:kForecastrIconsDefaultIconSize];
    }
    return iconImage;
}


@end
