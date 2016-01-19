//
//  Forecastr+Icons.h
//  PainTracker
//
//  Created by Wendy Kutschke on 12/10/15.
//  Copyright © 2015 Chronic Stimulation, LLC. All rights reserved.
//

#import "Forecastr.h"

#define kForecastrIconsDefaultIconSize CGSizeMake(64,64)
#define kForecastrIconFilenamePrefix @"FCIcon_"
#define kForecastrIconIconNotAvailableFilename @"iconNotAvailable"

@class FCForecast;
@interface Forecastr (Icons)

-(NSString *)refinedIconImageFilenameFromIconName:(NSString *)iconName daytime:(BOOL)daytime;

-(UIImage *)iconImageForIconName:(NSString *)iconName daytime:(BOOL)daytime imageSize:(CGSize)imageSize scale:(CGFloat)scale;

-(UIImage *)iconForFilename:(NSString *)iconFilename size:(CGSize)iconSize scale:(CGFloat)scale;

@end
