//
//  FCForecastLocation.h
//  PainTracker
//
//  Created by Wendy Kutschke on 12/15/15.
//  Copyright © 2015 Chronic Stimulation, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FCForecastLocationCompletionHandler)();

@class FCForecast;
@interface FCForecastLocation : NSObject

@property (nonatomic, readonly, strong) NSNumber* latitude;
@property (nonatomic, readonly, strong) NSNumber* longitude;
@property (nonatomic, weak) FCForecast *forecast;
@property (nonatomic, readonly, assign) BOOL locationDataIsReady;
@property (nonatomic, readonly, strong) CLLocation *location;
@property (nonatomic, strong) CLPlacemark *placemark;


-(instancetype)initWithLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude forecast:(FCForecast *)forecast;
-(void)updateForecastLocationLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude;
- (void)reverseGeocodeForecastLocationWithCompletionHandler:(FCForecastLocationCompletionHandler)locationCompletionHandler;

-(NSString *)addressComponentStringForAddrBookKey:(NSString *)abKey;

@end
