//
//  FCForecastLocation.m
//  PainTracker
//
//  Created by Wendy Kutschke on 12/15/15.
//  Copyright © 2015 Chronic Stimulation, LLC. All rights reserved.
//

#import "FCForecastLocation.h"
#import "Forecastr+CLLocation.h"
#import "FCForecastModel.h"
#import <AddressBookUI/AddressBookUI.h>

@interface FCForecastLocation ()

@property (nonatomic, readwrite, strong) NSNumber* latitude;
@property (nonatomic, readwrite, strong) NSNumber* longitude;
@property (nonatomic, readwrite, strong) CLLocation *location;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) NSMutableArray *geocodingResults;
@property (nonatomic, readwrite, assign) BOOL locationDataIsReady;

@end


@implementation FCForecastLocation
@synthesize location = _location;

-(instancetype)initWithLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude forecast:(FCForecast *)forecast;
{
    self = [super init];
    if (self) {
        _geocodingResults = [NSMutableArray new];
        _geocoder = [[CLGeocoder alloc] init];

        NSAssert(nil != forecast,@"Forecast must not be nil");
        _forecast = forecast;

        if (nil != latitude && nil != longitude) {
            [self updateForecastLocationLatitude:latitude longitude:longitude];
        }
    }
    return self;
}

-(void)updateForecastLocationLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude;
{
    // Invalidate existing location information
    self.locationDataIsReady = NO;
    self.placemark = nil;
    self.addressDisplayString = nil;
    
    // Cancel any in-process geocoding since we're changing the location
    if ([self.geocoder isGeocoding]) {
        [self.geocoder cancelGeocode];
    }
    
    // Assign the new Lat/Lon values
    self.latitude = latitude;
    self.longitude = longitude;
    self.location = [[CLLocation alloc] initWithLatitude:[self.latitude doubleValue] longitude:[self.longitude doubleValue]];
    
    // Can only run the geocoding if both lat & lon are non-nil values
    if (nil != self.latitude && nil != self.longitude) {

        // Run the reverse Geocoding to get the address info
        [self reverseGeocodeForecastLocation];
    }
}

-(CLLocation *)location;
{
    if (nil != _location) {
        return _location;
    }
    
    _location = [[CLLocation alloc] initWithLatitude:[self.latitude doubleValue] longitude:[self.longitude doubleValue]];

    return _location;
}

-(NSString *)description;
{
    if (self.forecast && self.location) {
        if (self.locationDataIsReady) {
            return [NSString stringWithFormat:@"FCForecastLocation for FCForecast: %@ at location: %@ generated CLPlacemark: %@ (%@)",self.forecast,self.location,self.placemark,self.addressDisplayString];
        } else {
            return [NSString stringWithFormat:@"FCForecastLocation for FCForecast: %@ at location: %@ has not generated geocoded placemark data yet.",self.forecast,self.location];
        }
    } else {
        return [NSString stringWithFormat:@"FCForecastLocation is missing FCForecast: %@ AND/OR location: %@ data.",self.forecast,self.location];
    }
}

#pragma mark - Geocoding methods

- (void)reverseGeocodeForecastLocation;
{
    if ([self.geocoder isGeocoding]) {
        [self.geocoder cancelGeocode];
    }
    
    if (nil != self.location) {
        [self.geocoder reverseGeocodeLocation:self.location
                        completionHandler:^(NSArray *placemarks, NSError *error) {
                            if (!error)
                                [self processReverseGeocodingResults:placemarks];
                        }];
    }
}

- (void)processReverseGeocodingResults:(NSArray *)placemarks {
    
    if ([placemarks count] == 0) {
        return;
    }
    
    self.geocodingResults = [placemarks copy];
    self.placemark = (CLPlacemark *)[self.geocodingResults objectAtIndex:0];

    self.addressDisplayString = ABCreateStringWithAddressDictionary(self.placemark.addressDictionary, YES); // requires AddressBookUI framework

    self.locationDataIsReady = YES;
}


@end
