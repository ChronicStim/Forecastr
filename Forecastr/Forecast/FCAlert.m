//
//  FCAlert.m
//  PainTracker
//
//  Created by Wendy Kutschke on 12/9/15.
//  Copyright © 2015 Chronic Stimulation, LLC. All rights reserved.
//

#import "FCAlert.h"

@implementation FCAlert

+(EKObjectMapping *)objectMapping;
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        
        [mapping mapPropertiesFromDictionary:@{
                                               @"description" : @"alertDescription",
                                               @"title" : @"title"
                                               }];
        
        [mapping mapKeyPath:@"time" toProperty:@"fcAlertDate" withValueBlock:^id(NSString *key, id value) {
            return (NSDate *)[NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
        }];
        
        [mapping mapKeyPath:@"expires" toProperty:@"expires" withValueBlock:^id(NSString *key, id value) {
            return (NSDate *)[NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
        }];
        
        [mapping mapKeyPath:@"uri" toProperty:@"url" withValueBlock:^id(NSString *key, id value) {
            return (NSURL *)[NSURL URLWithString:(NSString *)value];
        }];
        
    }];
}

@end
