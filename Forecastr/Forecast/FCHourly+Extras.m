//
//  FCHourly+Extras.m
//  PainTracker
//
//  Created by Wendy Kutschke on 12/11/15.
//  Copyright © 2015 Chronic Stimulation, LLC. All rights reserved.
//

#import "FCHourly+Extras.h"
#import "Forecastr+Icons.h"
#import "FCForecast+Extras.h"
#import "FCCurrently+Extras.h"

@implementation FCHourly (Extras)

-(UIImage *)iconHourly;
{
    UIImage *iconImage = nil;
    if (nil != self.iconName) {
        BOOL useDaytimeImage = [self.forecast.currently isItDaytime];
        iconImage = [[Forecastr sharedManager] iconImageForIconName:self.iconName daytime:useDaytimeImage imageSize:kForecastrIconsDefaultIconSize scale:0];
    }
    return iconImage;
}

@end
