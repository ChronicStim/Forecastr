//
//  Forecastr+Icons.h
//  PainTracker
//
//  Created by Wendy Kutschke on 12/10/15.
//  Copyright © 2015 Chronic Stimulation, LLC. All rights reserved.
//

#import "Forecastr.h"

#define kForecastrIconsDefaultIconSize CGSizeMake(64,64)

@interface Forecastr (Icons)

-(UIImage *)iconImageForIconName:(NSString *)iconName daytime:(BOOL)daytime imageSize:(CGSize)imageSize;

@end
