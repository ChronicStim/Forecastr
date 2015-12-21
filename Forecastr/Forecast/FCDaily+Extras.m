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

-(NSString *)moonPhaseDescription;
{
    if (nil != self.moonPhase) {
        NSUInteger phaseIndex = (NSUInteger)roundf([self.moonPhase doubleValue] * 8.0f);
        if (8 <= phaseIndex) {
            phaseIndex = 0;
        }
        NSString *phaseName;
        switch (phaseIndex) {
            case 0:
                phaseName = NSLocalizedString(@"New", @"New");
                break;
            case 1:
                phaseName = NSLocalizedString(@"Waxing Crescent", @"Waxing Crescent");
                break;
            case 2:
                phaseName = NSLocalizedString(@"First Quarter", @"First Quarter");
                break;
            case 3:
                phaseName = NSLocalizedString(@"Waxing Gibbous", @"Waxing Crescent");
                break;
            case 4:
                phaseName = NSLocalizedString(@"Full", @"Full");
                break;
            case 5:
                phaseName = NSLocalizedString(@"Waning Gibbous", @"Waning Gibbous");
                break;
            case 6:
                phaseName = NSLocalizedString(@"Last Quarter", @"Last Quarter");
                break;
            case 7:
                phaseName = NSLocalizedString(@"Waning Crescent", @"Waning Crescent");
                break;
            default:
                phaseName = @"Undefined";
                break;
        }
        return phaseName;
    }
    return nil;
}

@end
