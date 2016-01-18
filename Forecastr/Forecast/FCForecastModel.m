//
//  FCForecastModel.m
//  PainTracker
//
//  Created by Wendy Kutschke on 1/18/16.
//  Copyright © 2016 Chronic Stimulation, LLC. All rights reserved.
//

#import "FCForecastModel.h"

@implementation FCForecastModel

+(EKObjectMapping *)objectMapping;
{
    // To be defined for each subclass as needed
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        
    }];
}

@end
