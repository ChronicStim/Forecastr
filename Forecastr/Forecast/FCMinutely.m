//
//  FCMinutely.m
//  PainTracker
//
//  Created by Wendy Kutschke on 12/9/15.
//  Copyright © 2015 Chronic Stimulation, LLC. All rights reserved.
//

#import "FCMinutely.h"

@implementation FCMinutely

+(EKObjectMapping *)objectMapping;
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        
        [mapping mapPropertiesFromDictionary:@{
                                               @"precipIntensity" : @"precipIntensity",
                                               @"precipProbability" : @"precipProbability",
                                               @"precipType" : @"precipType"
                                               }];
        
        [mapping mapKeyPath:@"time" toProperty:@"fcMinutelyDate" withValueBlock:^id(NSString *key, id value) {
            return (NSDate *)[NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
        } reverseBlock:^id(id value) {
            return [NSNumber numberWithDouble:[(NSDate *)value timeIntervalSince1970]];
        }];
        
    }];
}

@end
