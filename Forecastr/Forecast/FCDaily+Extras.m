//
//  FCDaily+Extras.m
//  PainTracker
//
//  Created by Wendy Kutschke on 12/11/15.
//  Copyright © 2015 Chronic Stimulation, LLC. All rights reserved.
//

#import "FCDaily+Extras.h"
#import "FCForecastModel.h"
#import "Forecastr+Icons.h"

@implementation FCDaily (Extras)


-(UIImage *)iconDaily;
{
    UIImage *iconImage = nil;
    if (nil != self.iconName) {
        BOOL useDaytimeImage = [self.forecast.currently isItDaytime];
        iconImage = [[Forecastr sharedManager] iconImageForIconName:self.iconName daytime:useDaytimeImage imageSize:kForecastrIconsDefaultIconSize];
    }
    return iconImage;
}

@end
