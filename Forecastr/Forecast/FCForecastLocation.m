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
@property (nonatomic, strong) NSDictionary *addressDictionary;

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

        // Watch for a change in the placemark property and then update the addressDictionary property accordingly
        [self bk_addObserverForKeyPath:@"placemark" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) task:^(id obj, NSDictionary *change) {
            
            CLPlacemark *oldPlacemark = (CLPlacemark *)[change objectForKey:NSKeyValueChangeOldKey];
            CLPlacemark *newPlacemark = (CLPlacemark *)[change objectForKey:NSKeyValueChangeNewKey];
            if ([oldPlacemark isEqual:newPlacemark]) {
                return;
            } else {
                if (nil != newPlacemark) {
                    [(FCForecastLocation *)obj setAddressDictionary:[newPlacemark addressDictionary]];
                } else {
                    [(FCForecastLocation *)obj setAddressDictionary:nil];
                }
            }
        }];
        
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
    
    // Cancel any in-process geocoding since we're changing the location
    if ([self.geocoder isGeocoding]) {
        [self.geocoder cancelGeocode];
    }
    
    // Assign the new Lat/Lon values
    self.latitude = latitude;
    self.longitude = longitude;
    self.location = [[CLLocation alloc] initWithLatitude:[self.latitude doubleValue] longitude:[self.longitude doubleValue]];
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
            return [NSString stringWithFormat:@"FCForecastLocation for FCForecast: %@ at location: %@ generated CLPlacemark: %@ (%@)",self.forecast,self.location,self.placemark,[self addressDisplayString]];
        } else {
            return [NSString stringWithFormat:@"FCForecastLocation for FCForecast: %@ at location: %@ has not generated geocoded placemark data yet.",self.forecast,self.location];
        }
    } else {
        return [NSString stringWithFormat:@"FCForecastLocation is missing FCForecast: %@ AND/OR location: %@ data.",self.forecast,self.location];
    }
}

-(NSString *)addressDisplayString;
{
    NSString *addressString = nil;
    if (nil != self.placemark) {
        if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
            // Post-iOS 9.0 need to use placemark components to build up address string manually
            addressString = @"TODO";
        } else {
            // Pre-iOS 9.0 can use ABPerson function to create full address string from placemark
            addressString = ABCreateStringWithAddressDictionary(self.placemark.addressDictionary, YES);
        }
    }
    return addressString;
}

-(NSString *)addressComponentStringForAddrBookKey:(NSString *)abKey;
{
    NSString *componentString = nil;
    if (nil != self.addressDictionary) {
        componentString = [self.addressDictionary objectForKey:abKey];
    }
    
    return componentString;
}

#pragma mark - Geocoding methods

- (void)reverseGeocodeForecastLocationWithCompletionHandler:(FCForecastLocationCompletionHandler)locationCompletionHandler;
{
    if ([self.geocoder isGeocoding]) {
        [self.geocoder cancelGeocode];
    }
    
    if (nil != self.location) {
        FCForecastLocation __weak *blockSelf = self;
        [self.geocoder reverseGeocodeLocation:self.location
                        completionHandler:^(NSArray *placemarks, NSError *error) {
                            if (!error) {
                                [blockSelf processReverseGeocodingResults:placemarks];
                            }
                            locationCompletionHandler();
                        }];
    }
}

- (void)processReverseGeocodingResults:(NSArray *)placemarks {
    
    if ([placemarks count] == 0) {
        return;
    }
    
    self.geocodingResults = [placemarks copy];
    self.placemark = (CLPlacemark *)[self.geocodingResults objectAtIndex:0];

    self.locationDataIsReady = YES;
    NSLog(@"ForecastLocation = %@",[self description]);
}


@end
