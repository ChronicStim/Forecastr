//
//  Forecastr+Icons.m
//  PainTracker
//
//  Created by Wendy Kutschke on 12/10/15.
//  Copyright © 2015 Chronic Stimulation, LLC. All rights reserved.
//

#import "Forecastr+Icons.h"
#import "FCForecastModel.h"

@implementation Forecastr (Icons)

-(BOOL)checkIfForecastrIconPrefixExistsOnIconName:(NSString *)iconName;
{
    return [iconName hasPrefix:kForecastrIconFilenamePrefix];
}

-(NSString *)refinedIconImageFilenameFromIconName:(NSString *)iconName daytime:(BOOL)daytime;
{
    if (nil == iconName) {
        return nil;
    }
    
    NSDictionary *mappingDict = [self iconFilenameMappingDictionary];
    if (nil == mappingDict) {
        return nil;
    }
    
    NSString *dayNightKey;
    if (daytime) {
        dayNightKey = @"daytimeIconFilename";
    } else {
        dayNightKey = @"nighttimeIconFilename";
    }
    
    // See if the iconName can be found in the mappingDict
    NSDictionary *iconDefinition = [mappingDict objectForKey:iconName];
    if (nil == iconDefinition || nil == [iconDefinition objectForKey:dayNightKey]) {
        // Can't find a mapping for this iconName. Rather than return a nil, default to an icon that indicates that we can't locate that icon.
        iconDefinition = [mappingDict objectForKey:kForecastrIconIconNotAvailableFilename];
    }
    
    // Get the appropriate day/night image from the definition
    NSString *imageFilename = [iconDefinition objectForKey:dayNightKey];

    if (nil != imageFilename) {
        // e.g. "FCIcon_partly-cloudy-day"
        return [NSString stringWithFormat:@"%@%@",kForecastrIconFilenamePrefix,imageFilename];
    }
    return nil;
}

-(UIImage *)iconImageForIconName:(NSString *)iconName daytime:(BOOL)daytime imageSize:(CGSize)imageSize scale:(CGFloat)scale;
{
    if (nil == iconName || CGSizeEqualToSize(imageSize, CGSizeZero)) {
        return nil;
    }
    
    // Get the appropriate day/night image from the definition
    NSString *imageFilename = [self refinedIconImageFilenameFromIconName:iconName daytime:daytime];
    
    // Generate the image and scale to size
    UIImage *iconImage = [self iconForFilename:imageFilename size:imageSize scale:scale];
    return iconImage;
}

-(UIImage *)iconForFilename:(NSString *)iconFilename size:(CGSize)iconSize scale:(CGFloat)scale;
{
    UIImage *iconImage = nil;
    if (nil != iconFilename) {
        // Generate the image and scale to size
        UIImage *rawIcon = [UIImage imageNamed:iconFilename];
        iconImage = [UIImage imageWithImage:rawIcon scaledToSize:iconSize scale:scale];
    }
    return iconImage;
}

-(NSDictionary *)iconFilenameMappingDictionary {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ForecastrIconMapping" ofType:@"plist"];
    NSDictionary *mappingDict = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    return mappingDict;
}

@end
