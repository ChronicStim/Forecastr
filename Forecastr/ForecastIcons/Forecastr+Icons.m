//
//  Forecastr+Icons.m
//  PainTracker
//
//  Created by Wendy Kutschke on 12/10/15.
//  Copyright © 2015 Chronic Stimulation, LLC. All rights reserved.
//

#import "Forecastr+Icons.h"
#import "UIImage+ForecastrAdditions.h"

@implementation Forecastr (Icons)

-(UIImage *)iconImageForIconName:(NSString *)iconName daytime:(BOOL)daytime imageSize:(CGSize)imageSize;
{
    if (nil == iconName || CGSizeEqualToSize(imageSize, CGSizeZero)) {
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
        // Can't find a mapping for this iconName. Rather than return a nil, let's just default to a partlyCloudy day/night option.
        iconDefinition = [mappingDict objectForKey:@"partly-cloudy-day"];
    }
    
    // Get the appropriate day/night image from the definition
    NSString *imageFilename = [iconDefinition objectForKey:dayNightKey];
    
    // Generate the image and scale to size
    UIImage *iconImage = nil;
    if (nil != imageFilename) {
        UIImage *rawIconFile = [UIImage imageNamed:imageFilename];
        iconImage = [UIImage imageWithImage:rawIconFile scaledToSize:imageSize];
    }
    return iconImage;
}

-(NSDictionary *)iconFilenameMappingDictionary {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ForecastrIconMapping" ofType:@"plist"];
    NSDictionary *mappingDict = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    return mappingDict;
}

@end
