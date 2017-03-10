//
//  Forecastr.m
//  Forecastr
//
//  Created by Rob Phillips on 4/3/13.
//  Copyright (c) 2013 Rob Phillips. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "Forecastr.h"
#import "AFNetworking.h"
#import "ForecastrAPIClient.h"

// Error domain & enums
NSString *const kFCErrorDomain = @"com.forecastr.errors";
typedef enum {
    kFCCachedItemNotFound,
    kFCCacheNotEnabled
} ForecastrErrorType;

typedef enum {
    WACR_APICallRejected = 0,
    WACR_APICallPermitted = 1
} WeatherAPICallResult;

// API Call Limit
NSString *const kFCAPICallLimitExceededWarning = @"ForecastrAPICallLimitExceeded";
NSString *const kFCAPIRecentCallDateKey = @"kFCAPIRecentCallDateKey";
NSString *const kFCAPIRecentCallResultKey = @"kFCAPIRecentCallResultKey";
NSString *const kFCAPIRecentCallClearingCode = @"CPTWeather2702";

// Cache keys
NSString *const kFCCacheKey = @"CachedForecasts";
NSString *const kFCCacheArchiveKey = @"ArchivedForecast";
NSString *const kFCCacheExpiresKey = @"ExpiresAt";
NSString *const kFCCacheForecastKey = @"Forecast";
NSString *const kFCCacheJSONPKey = @"JSONP";

/**
 * A common area for changing the names of all constants used in the JSON response
 */

// Unit types
NSString *const kFCUSUnits = @"us";
NSString *const kFCSIUnits = @"si";
NSString *const kFCUKUnits = @"uk2";
NSString *const kFCCAUnits = @"ca";
NSString *const kFCAutoUnits = @"auto";

// Languages
NSString *const kFCLanguageBosnian = @"bs";
NSString *const kFCLanguageGerman = @"de";
NSString *const kFCLanguageEnglish = @"en"; // Default
NSString *const kFCLanguageSpanish = @"es";
NSString *const kFCLanguageFrench = @"fr";
NSString *const kFCLanguageItalian = @"it";
NSString *const kFCLanguageDutch = @"nl";
NSString *const kFCLanguagePolish = @"pl";
NSString *const kFCLanguagePortuguese = @"pt";
NSString *const kFCLanguageTetum = @"tet";
NSString *const kFCLanguagePigLatin = @"x-pig-latin";

// Extend types
NSString *const kFCExtendHourly = @"hourly";

// Forecast names used for the data block hash keys
NSString *const kFCCurrentlyForecast = @"currently";
NSString *const kFCMinutelyForecast = @"minutely";
NSString *const kFCHourlyForecast = @"hourly";
NSString *const kFCDailyForecast = @"daily";

// Additional names used for the data block hash keys
NSString *const kFCAlerts = @"alerts";
NSString *const kFCFlags = @"flags";
NSString *const kFCLatitude = @"latitude";
NSString *const kFCLongitude = @"longitude";
NSString *const kFCOffset = @"offset";
NSString *const kFCTimezone = @"timezone";

// Names used for the data point hash keys
NSString *const kFCCloudCover = @"cloudCover";
NSString *const kFCCloudCoverError = @"cloudCoverError";
NSString *const kFCDewPoint = @"dewPoint";
NSString *const kFCHumidity = @"humidity";
NSString *const kFCHumidityError = @"humidityError";
NSString *const kFCIcon = @"icon";
NSString *const kFCMoonPhase = @"moonPhase";
NSString *const kFCOzone = @"ozone";
NSString *const kFCPrecipAccumulation = @"precipAccumulation";
NSString *const kFCPrecipIntensity = @"precipIntensity";
NSString *const kFCPrecipIntensityMax = @"precipIntensityMax";
NSString *const kFCPrecipIntensityMaxTime = @"precipIntensityMaxTime";
NSString *const kFCPrecipProbability = @"precipProbability";
NSString *const kFCPrecipType = @"precipType";
NSString *const kFCPressure = @"pressure";
NSString *const kFCPressureError = @"pressureError";
NSString *const kFCSummary = @"summary";
NSString *const kFCSunriseTime = @"sunriseTime";
NSString *const kFCSunsetTime = @"sunsetTime";
NSString *const kFCTemperature = @"temperature";
NSString *const kFCTemperatureMax = @"temperatureMax";
NSString *const kFCTemperatureMaxError = @"temperatureMaxError";
NSString *const kFCTemperatureMaxTime = @"temperatureMaxTime";
NSString *const kFCTemperatureMin = @"temperatureMin";
NSString *const kFCTemperatureMinError = @"temperatureMinError";
NSString *const kFCTemperatureMinTime = @"temperatureMinTime";
NSString *const kFCApparentTemperature = @"apparentTemperature";
NSString *const kFCTime = @"time";
NSString *const kFCVisibility = @"visibility";
NSString *const kFCVisibilityError = @"visibilityError";
NSString *const kFCWindBearing = @"windBearing";
NSString *const kFCWindSpeed = @"windSpeed";
NSString *const kFCWindSpeedError = @"windSpeedError";

// Names used for weather icons
NSString *const kFCIconClearDay = @"clear-day";
NSString *const kFCIconClearNight = @"clear-night";
NSString *const kFCIconRain = @"rain";
NSString *const kFCIconSnow = @"snow";
NSString *const kFCIconSleet = @"sleet";
NSString *const kFCIconWind = @"wind";
NSString *const kFCIconFog = @"fog";
NSString *const kFCIconCloudy = @"cloudy";
NSString *const kFCIconPartlyCloudyDay = @"partly-cloudy-day";
NSString *const kFCIconPartlyCloudyNight = @"partly-cloudy-night";
NSString *const kFCIconHail = @"hail";
NSString *const kFCIconThunderstorm = @"thunderstorm";
NSString *const kFCIconTornado = @"tornado";
NSString *const kFCIconHurricane = @"hurricane";

// A numerical value representing the distance to the nearest storm
NSString *const kFCNearestStormDistance = @"nearestStormDistance";
NSString *const kFCNearestStormBearing = @"nearestStormBearing";

// Keys for the apiActivityTracker
BOOL const kFCAPIActivityTrackerIsActive = YES;
NSString *const kFCAPIActivityTrackerRecentAPICallDates = @"kFCAPIActivityTrackerRecentAPICallDates";
NSString *const kFCAPIActivityTrackerAPICallRejectedDates = @"kFCAPIActivityTrackerAPICallRejectedDates";
NSUInteger const kFCAPIActivityTrackerMaxAPICallsPer24HourPeriod = 250;
NSTimeInterval const kFCAPIActivityTrackerCleanoutOperationTimerInterval = 300; // Run cleanout every 5 minutes

@interface Forecastr ()
{
    NSUserDefaults *userDefaults;
    
    dispatch_queue_t async_queue;
    
    BOOL _trackAPIActivity;
    NSTimer *_apiActivityTrackerTimer;
    
}
@property (nonatomic, strong) NSMutableSet *apiActivityRecentAPICallDates;
@property (nonatomic, strong) NSOperationQueue *apiActivityTrackingOpQueue;
@property (nonatomic, strong) NSDateFormatter *forecastrDateFormatter;

@end

@implementation Forecastr

# pragma mark - Singleton Methods

+ (id)sharedManager
{
    static Forecastr *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (id)init {
    if (self = [super init]) {
        // Init code here
        userDefaults = [NSUserDefaults standardUserDefaults];
        
        // Locale defaults
        self.language = kFCLanguageEnglish;
        self.units = kFCUSUnits;
        
        // Setup the async queue
        async_queue = dispatch_queue_create("com.forecastr.asyncQueue", NULL);
        
        // Caching defaults
        self.cacheEnabled = YES; // Enable cache by default
        self.cacheExpirationInMinutes = 30; // Set default of 30 minutes
        self.requestHTTPCompression = YES; // Set default to YES for forecast.io
        
        // Setup KVO monitoring of key properties that effect when cache needs to be flushed
        [self addObserver:self forKeyPath:@"language" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:nil];
        [self addObserver:self forKeyPath:@"units" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:nil];
        
        // Setup APITracking & periodic cleanout timer
        _trackAPIActivity = kFCAPIActivityTrackerIsActive;
        if (_trackAPIActivity) {
            [self enabledAPICallTracking];
        }
    }
    return self;
}

-(void)dealloc
{
    if (_apiActivityTrackerTimer) {
        [_apiActivityTrackerTimer invalidate];
    }
}

-(NSDateFormatter *)forecastrDateFormatter;
{
    if (nil != _forecastrDateFormatter)
        return _forecastrDateFormatter;
    
    _forecastrDateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [_forecastrDateFormatter setLocale:enUSPOSIXLocale];
    [_forecastrDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSS"];
    return _forecastrDateFormatter;
}

#pragma mark - API Call Tracking Methods

-(void)enabledAPICallTracking;
{
    // Run the call tracking cleanout process immediately on startup
    [self cleanoutAPIActivityTrackerOnBackgroundThread];
    
    // Also setup a reoccuring timer to run the process
    __weak __typeof__(self) weakSelf = self;
    _apiActivityTrackerTimer = [NSTimer bk_scheduledTimerWithTimeInterval:kFCAPIActivityTrackerCleanoutOperationTimerInterval block:^(NSTimer *timer) {
        [weakSelf cleanoutAPIActivityTrackerOnBackgroundThread];
    } repeats:YES];
    
    //* FOR DEBUGGING ONLY *//
    //[self testingClearAPITrackers];
    //[self testingPreloadAPITrackerWithSome:20 randomCallsFromBetweenStartHours:24 stopHoursAgo:0];
}

-(NSOperationQueue *)apiActivityTrackingOpQueue;
{
    if (nil != _apiActivityTrackingOpQueue) {
        return _apiActivityTrackingOpQueue;
    }
    
    _apiActivityTrackingOpQueue = [[NSOperationQueue alloc] init];
    _apiActivityTrackingOpQueue.underlyingQueue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0);
    _apiActivityTrackingOpQueue.name = @"Weather API Activity Tracking Op Queue";
    _apiActivityTrackingOpQueue.maxConcurrentOperationCount = 1;
    
    return _apiActivityTrackingOpQueue;
}

-(NSMutableSet *)apiActivityRecentAPICallDates;
{
    if (nil != _apiActivityRecentAPICallDates) {
        return _apiActivityRecentAPICallDates;
    }
    
    @synchronized (_apiActivityRecentAPICallDates) {
        _apiActivityRecentAPICallDates = [self reloadAPIActivityRecentAPICallDates];
    }
    return _apiActivityRecentAPICallDates;
}

-(NSMutableSet *)reloadAPIActivityRecentAPICallDates;
{
    NSMutableSet *newRecentAPICallDateSet = [NSMutableSet new];
    NSArray *existingCalls = [userDefaults objectForKey:kFCAPIActivityTrackerRecentAPICallDates];
    
    // Filter out any legacy v3.8.4 NSDate objects. We just want the NSDict objects
    NSArray *filteredCalls = [existingCalls bk_select:^BOOL(id obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            return YES;
        }
        return NO;
    }];
    
    if (nil != filteredCalls) {
        [newRecentAPICallDateSet addObjectsFromArray:filteredCalls];
    }
    return newRecentAPICallDateSet;
}

-(void)updateAPIActivityTrackerWithAllowedCall:(BOOL)allowed forDate:(NSDate *)callDate;
{
    NSSet *initialSet = self.apiActivityRecentAPICallDates ? [self.apiActivityRecentAPICallDates copy] : [NSSet new];
    NSMutableArray *arrayToUpdate = [[NSMutableArray alloc] initWithArray:[initialSet allObjects]];
    NSString *setKey = nil;
    if (allowed) {
        [arrayToUpdate addObject:@{kFCAPIRecentCallDateKey : callDate, kFCAPIRecentCallResultKey : @(WACR_APICallPermitted)}];
        setKey = kFCAPIActivityTrackerRecentAPICallDates;
    }
    else {
        [arrayToUpdate addObject:@{kFCAPIRecentCallDateKey : callDate, kFCAPIRecentCallResultKey : @(WACR_APICallRejected)}];
        setKey = kFCAPIActivityTrackerRecentAPICallDates;
    }
    
    __weak __typeof__(self) weakSelf = self;
    [self.apiActivityTrackingOpQueue addOperationWithBlock:^{
        [weakSelf synchronizeToUserDefaultsForAPITrackingArray:arrayToUpdate forKey:setKey];
    }];
    DDLogVerbose(@"Weather API %@ allow a call on %@",(allowed ? @"DID" : @"DID NOT"),[self.forecastrDateFormatter stringFromDate:callDate]);
}

-(void)synchronizeToUserDefaultsForAPITrackingArray:(NSArray *)arrayToSync forKey:(NSString *)keyForSet;
{
    if (nil != arrayToSync && nil != keyForSet) {
        [userDefaults setObject:arrayToSync forKey:keyForSet];
        [userDefaults synchronize];
        @synchronized (_apiActivityRecentAPICallDates) {
            _apiActivityRecentAPICallDates = [self reloadAPIActivityRecentAPICallDates];
        }
    }
}

-(BOOL)checkIfOKToCallAPINow;
{
    BOOL allowCall = NO;
    NSUInteger __block permittedCount = 0;
    [[self.apiActivityRecentAPICallDates allObjects] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ((WeatherAPICallResult)[[(NSDictionary *)obj objectForKey:kFCAPIRecentCallResultKey] intValue] == WACR_APICallPermitted) {
            permittedCount++;
        }
    }];
    
    if (kFCAPIActivityTrackerMaxAPICallsPer24HourPeriod > permittedCount) {
        allowCall = YES;
    }
    
    __weak __typeof__(self) weakSelf = self;
    [self.apiActivityTrackingOpQueue addOperationWithBlock:^{
        [weakSelf updateAPIActivityTrackerWithAllowedCall:allowCall forDate:[NSDate date]];
    }];
    
    if (!allowCall) {
        // Notify user that API is temporarily locked
        [self informUserThatAPILimitsHaveBeenExceeded];
    }
    
    return allowCall;
}

-(void)cleanoutAPIActivityTrackerOnBackgroundThread;
{
    __weak __typeof__(self) weakSelf = self;
    [self.apiActivityTrackingOpQueue addOperationWithBlock:^{
        __typeof__(self) strongSelf = weakSelf;
        [strongSelf cleanoutAPIActivityTrackerForCallsOlderThanHours:24];
    }];
}

-(void)cleanoutAPIActivityTrackerForCallsOlderThanHours:(NSInteger)hours;
{
    NSMutableSet *copyOfRecentCallDates = [self.apiActivityRecentAPICallDates mutableCopy];
    
    int origCount = (int)[copyOfRecentCallDates count];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - ((60 * 60) * hours);
    NSDate *checkDate = [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
    
    NSSet *callsToRemove = [copyOfRecentCallDates bk_select:^BOOL(id obj) {
        
        // Include a check to remove legacy values from v3.8.4 where calls were stored as NSDate rather than NSDict
        if ([obj isKindOfClass:[NSDate class]]) {
            return YES;
        }
        
        // Check call date stored in the dictionary obj
        NSDate *callDate = (NSDate *)[(NSDictionary *)obj objectForKey:kFCAPIRecentCallDateKey];
        if ([callDate laterDate:checkDate] == checkDate) {
            return YES;
        }
        return NO;
    }];
    
    for (id call in callsToRemove) {
        [copyOfRecentCallDates removeObject:call];
    }
    
    // Update the recent calls data if there was a change
    if (nil != callsToRemove && 0 < [callsToRemove count]) {
        
        NSArray *arrayToUpdate = [NSArray arrayWithArray:[copyOfRecentCallDates allObjects]];
        __weak __typeof__(self) weakSelf = self;
        [self.apiActivityTrackingOpQueue addOperationWithBlock:^{
            [weakSelf synchronizeToUserDefaultsForAPITrackingArray:arrayToUpdate forKey:kFCAPIActivityTrackerRecentAPICallDates];
        }];

        // Reset the ivar which will cause the property to reload from user defaults the next time its referenced
        _apiActivityRecentAPICallDates = nil;
    }
    
    int newCount = (int)[copyOfRecentCallDates count];
    DDLogVerbose(@"Weather API cleanout process removed %i calls from the collection. Orig: %i; New: %i",(origCount-newCount),origCount,newCount);
}

-(void)informUserThatAPILimitsHaveBeenExceeded;
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *title = NSLocalizedString(@"Weather API Call Requests Exceeded", @"Weather API Call Requests Exceeded");
        NSString *message = [NSString stringWithFormat:@"You have exceeded the number of allowed API calls to Weather Data Service. The policy within Chronic Pain Tracker permits a maximum of %lu API calls per 24 hour period. Please wait 15-30 minutes and then try your request again.",(unsigned long)kFCAPIActivityTrackerMaxAPICallsPer24HourPeriod];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"OK") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:okAction];
        
        UIViewController *activeVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        [activeVC presentViewController:alertController animated:YES completion:nil];
    });
}

-(void)testingPreloadAPITrackerWithSome:(NSInteger)callCount randomCallsFromBetweenStartHours:(NSInteger)startHours stopHoursAgo:(NSInteger)stopHours;
{
    NSAssert(startHours > stopHours,@"StartHours value must be larger than the stopHours value.");
    NSInteger callTimeRange = (60*60*(startHours-stopHours));
    NSInteger callTimeOffset = -(60*60*stopHours);
    NSDate *now = [NSDate date];
    
    NSMutableSet *randomCallDates = [NSMutableSet new];
    NSDate *earlyDate = [NSDate date];
    NSDate *lateDate = [NSDate date];
    for (int i=0; i<callCount; i++) {
        
        NSInteger randomTimeInterval = ((-(arc4random() % callTimeRange)) + callTimeOffset);
        NSDate *randomDate = [now dateByAddingTimeInterval:randomTimeInterval];
        
        if ([randomDate earlierDate:earlyDate] == randomDate) {
            earlyDate = [randomDate copy];
        }
        if ([randomDate laterDate:lateDate] == randomDate) {
            lateDate = [randomDate copy];
        }
        [randomCallDates addObject:randomDate];
    }
    
    DDLogVerbose(@"Weather API Testing is adding %lu random call dates to the recent call data (%lu existing calls). Earliest random call = %@; Latest random call = %@",(unsigned long)[randomCallDates count],(unsigned long)[self.apiActivityRecentAPICallDates count],earlyDate,lateDate);
    [self.apiActivityRecentAPICallDates addObjectsFromArray:[randomCallDates allObjects]];
    [self cleanoutAPIActivityTrackerOnBackgroundThread];
}

-(void)clearAPITrackeringCache;
{
    DDLogVerbose(@"Weather API Testing is clearing tracking data. Pre-reset Counts => Total Recent calls (%lu)->0 ; Permitted Calls (%lu)->0; Rejected Calls (%lu)->0",(unsigned long)[self.apiActivityRecentAPICallDates count],(unsigned long)[self countOfRecentAPICallsWithResult:WACR_APICallPermitted],(unsigned long)[self countOfRecentAPICallsWithResult:WACR_APICallRejected]);
    
    // Update the recent calls data
    [self synchronizeToUserDefaultsForAPITrackingArray:[NSArray new] forKey:kFCAPIActivityTrackerRecentAPICallDates];
    
    // Reset the ivar which will cause the property to reload from user defaults the next time its referenced
    _apiActivityRecentAPICallDates = nil;
}

-(NSInteger)countOfRecentAPICallsWithResult:(WeatherAPICallResult)callResult;
{
    NSUInteger callCount = [[self.apiActivityRecentAPICallDates bk_select:^BOOL(id obj) {
        if ((WeatherAPICallResult)[[(NSDictionary *)obj objectForKey:kFCAPIRecentCallResultKey] intValue] == callResult) {
            return YES;
        }
        return NO;
    }] count];
    return (NSInteger)callCount;
}

-(NSString *)messageForSettingsAlertViewRequestingAPICallTrackingCacheReset;
{
    // Count the permitted calls in the cache
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        if ((WeatherAPICallResult)[[(NSDictionary *)evaluatedObject objectForKey:kFCAPIRecentCallResultKey] intValue] == WACR_APICallPermitted) {
            return YES;
        }
        return NO;
    }];
    NSUInteger permittedCalls = [[self.apiActivityRecentAPICallDates filteredSetUsingPredicate:predicate] count];
    
    return [NSString stringWithFormat:@"The Weather API tracking cache indicates %li api calls in the last 24 hours. This cache will refresh every 24 hours, but can be cleared manually using a code supplied by the CPT Support Staff. Do you wish to clear the cache using an override code?",(long)permittedCalls];
}

-(BOOL)allowAPICallTrackingCacheResetWithSecurityCode:(NSString *)securityCode;
{
    BOOL allowReset = NO;
    if (nil != securityCode && 0 < [securityCode length]) {
        if ([securityCode isEqualToString:kFCAPIRecentCallClearingCode]) {
            allowReset = YES;
            __weak __typeof__(self) weakSelf = self;
            [self.apiActivityTrackingOpQueue addOperationWithBlock:^{
                [weakSelf clearAPITrackeringCache];
            }];
        }
    }
    return allowReset;
}

# pragma mark - Instance Methods

- (void)getForecastForLatitude:(double)lat
                     longitude:(double)lon
                          time:(NSNumber *)time
                    exclusions:(NSArray *)exclusions
                       success:(void (^)(id JSON))success
                       failure:(void (^)(NSError *error, id response))failure
{
    [self getForecastForLatitude:lat longitude:lon time:time exclusions:exclusions extend:nil success:success failure:failure];
}

- (void)getForecastForLatitude:(double)lat
                     longitude:(double)lon
                          time:(NSNumber *)time
                    exclusions:(NSArray *)exclusions
                        extend:(NSString *)extendCommand
                       success:(void (^)(id JSON))success
                       failure:(void (^)(NSError *error, id response))failure
{
    [self getForecastForLatitude:lat longitude:lon time:time exclusions:exclusions extend:nil language:nil success:success failure:failure];
}

// Requests the specified forecast for the given location and optional parameters
- (void)getForecastForLatitude:(double)lat
                     longitude:(double)lon
                          time:(NSNumber *)time
                    exclusions:(NSArray *)exclusions
                        extend:(NSString *)extendCommand
                      language:(NSString *)languageCode
                       success:(void (^)(id JSON))success
                       failure:(void (^)(NSError *error, id response))failure
{
    // Check if we have an API key set
    [self checkForAPIKey];
    
    // If languageCode is NIL, but language property has been set, then use that in request
    languageCode = (nil == languageCode) ? self.language : languageCode;
    
    // Generate the URL string based on the passed in params
    NSString *urlString = [self urlStringforLatitude:lat longitude:lon time:time exclusions:exclusions extend:(NSString *)extendCommand language:languageCode];
    
#ifndef NDEBUG
    NSLog(@"Forecastr: Checking forecast for %@", urlString);
#endif
    
    NSString *callback = self.callback;
    
    // Check if we have a valid cache item that hasn't expired for this URL
    // If caching isn't enabled or a fresh cache item wasn't found, it will execute a server request in the failure block
    NSString *cacheKey = [self cacheKeyForURLString:urlString forLatitude:lat longitude:lon];
    [self checkForecastCacheForURLString:cacheKey success:^(id cachedForecast) {
        success(cachedForecast);
    } failure:^(NSError *error) {
        // If we got here, cache isn't enabled or we didn't find a valid/unexpired forecast
        // for this location in cache so let's query the servers for one
        
        // Check if user has exceeded the number of API calls allowed before proceeding
        if (!_trackAPIActivity || [self checkIfOKToCallAPINow]) {
            // Asynchronously kick off the GET request on the API for the generated URL (i.e. not the one used as a cache key)
            if (callback) {
                
                if (self.requestHTTPCompression) {
                    [ForecastrAPIClient sharedClient].requestSerializer = [AFHTTPRequestSerializer serializer];
                    [(AFHTTPRequestSerializer *)[ForecastrAPIClient sharedClient].requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
                }
                [ForecastrAPIClient sharedClient].responseSerializer = [AFHTTPResponseSerializer serializer];
                [[ForecastrAPIClient sharedClient] GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    NSString *JSONP = [[NSString alloc] initWithData:responseObject encoding:NSASCIIStringEncoding];
                    if (self.cacheEnabled) [self cacheForecast:JSONP withURLString:cacheKey];
                    [ForecastrAPIClient sharedClient].responseSerializer = [AFJSONResponseSerializer serializer];
                    success(JSONP);
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                    [ForecastrAPIClient sharedClient].responseSerializer = [AFJSONResponseSerializer serializer];
                    failure(error, response);
                }];
                
            } else {
                if (self.requestHTTPCompression) {
                    [ForecastrAPIClient sharedClient].requestSerializer = [AFHTTPRequestSerializer serializer];
                    [(AFHTTPRequestSerializer *)[ForecastrAPIClient sharedClient].requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
                }
                [[ForecastrAPIClient sharedClient] GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id JSON) {
                    if (self.cacheEnabled) [self cacheForecast:JSON withURLString:cacheKey];
                    success(JSON);
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                    failure(error, response);
                }];
                
            }
        }
        else {
            // Too many calls to the API. Gracefully fail the request
            failure(nil, kFCAPICallLimitExceededWarning);
        }
    }];
}

// Cancels all requests that are currently queued or being executed
- (void)cancelAllForecastRequests
{
    for (id task in [[ForecastrAPIClient sharedClient] tasks]) {
        if ([task respondsToSelector:@selector(cancel)]) {
            [task cancel];
        }
    }
}

// Returns a description based on the precicipation intensity
- (NSString *)descriptionForPrecipIntensity:(float)precipIntensity
{
    if (precipIntensity < 0.002) { return @"None"; }
    if (precipIntensity < 0.017) { return @"Very light"; }
    if (precipIntensity < 0.1) { return @"Light"; }
    if (precipIntensity < 0.4) { return @"Moderate"; }
    else return @"Heavy";
}

// Returns a description based on the cloud cover percentage
- (NSString *)descriptionForCloudCoverPercentage:(float)cloudCover
{
    if (cloudCover < 0.2) { return @"clear sky"; }
    if (cloudCover < 0.4) { return @"widely scattered"; }
    if (cloudCover < 0.6) { return @"partly cloudy"; }
    if (cloudCover < 0.8) { return @"mostly cloudy"; }
    else return @"overcast";
}

// Returns an image name based on the weather icon type
- (NSString *)imageNameForWeatherIconType:(NSString *)iconDescription
{
    if ([iconDescription isEqualToString:kFCIconClearDay]) { return @"clearDay.png"; }
    else if ([iconDescription isEqualToString:kFCIconClearNight]) { return @"clearNight.png"; }
    else if ([iconDescription isEqualToString:kFCIconRain]) { return @"rain.png"; }
    else if ([iconDescription isEqualToString:kFCIconSnow]) { return @"snow.png"; }
    else if ([iconDescription isEqualToString:kFCIconSleet]) { return @"sleet.png"; }
    else if ([iconDescription isEqualToString:kFCIconWind]) { return @"wind.png"; }
    else if ([iconDescription isEqualToString:kFCIconFog]) { return @"fog.png"; }
    else if ([iconDescription isEqualToString:kFCIconCloudy]) { return @"cloudy.png"; }
    else if ([iconDescription isEqualToString:kFCIconPartlyCloudyDay]) { return @"partlyCloudyDay.png"; }
    else if ([iconDescription isEqualToString:kFCIconPartlyCloudyNight]) { return @"partlyCloudyNight.png"; }
    else if ([iconDescription isEqualToString:kFCIconHail]) { return @"hail.png"; }
    else if ([iconDescription isEqualToString:kFCIconThunderstorm]) { return @"thunderstorm.png"; }
    else if ([iconDescription isEqualToString:kFCIconTornado]) { return @"tornado.png"; }
    else if ([iconDescription isEqualToString:kFCIconHurricane]) { return @"hurricane.png"; }
    else return @"cloudy.png"; // Default in case nothing matched
}

// Returns a string with the JSON error message, if given, or the appropriate localized description for the NSError object
- (NSString *)messageForError:(NSError *)error withResponse:(id)response
{
    if ([response isKindOfClass:[NSDictionary class]]) {
        NSString *errorMsg = [response objectForKey:@"error"];
        return (errorMsg.length) ? errorMsg : error.localizedDescription;
    } else if ([response isKindOfClass:[AFHTTPRequestOperation class]]) {
        AFHTTPRequestOperation *operation = (AFHTTPRequestOperation *)response;
        NSInteger statusCode = operation.response.statusCode;
        NSString *errorMsg = [NSHTTPURLResponse localizedStringForStatusCode:statusCode];
        return [errorMsg stringByAppendingFormat:@" (code %ld)", (long)statusCode];
    } else {
        return error.localizedDescription;
    }
}

# pragma mark - Private Methods

// Check for an empty API key
- (void)checkForAPIKey
{
    if (!self.apiKey || !self.apiKey.length) {
        [NSException raise:@"Forecastr" format:@"Your Forecast.io API key must be populated before you can access the API.", nil];
    }
}

// Generates a URL string for the given options
- (NSString *)urlStringforLatitude:(double)lat longitude:(double)lon time:(NSNumber *)time exclusions:(NSArray *)exclusions extend:(NSString *)extendCommand language:(NSString *)languageCode
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%.6f,%.6f", self.apiKey, lat, lon];
    if (time) urlString = [urlString stringByAppendingFormat:@",%.0f", [time doubleValue]];
    if (exclusions) urlString = [urlString stringByAppendingFormat:@"?exclude=%@", [self stringForExclusions:exclusions]];
    if (extendCommand) urlString = [urlString stringByAppendingFormat:@"%@extend=%@", exclusions ? @"&" : @"?", extendCommand];
    if (languageCode) urlString = [urlString stringByAppendingFormat:@"%@lang=%@", (exclusions || extendCommand) ? @"&" : @"?", languageCode];
    if (self.units) urlString = [urlString stringByAppendingFormat:@"%@units=%@", (exclusions || extendCommand || languageCode) ? @"&" : @"?", self.units];
    if (self.callback) urlString = [urlString stringByAppendingFormat:@"%@callback=%@", (exclusions || self.units || extendCommand || languageCode) ? @"&" : @"?", self.callback];
    return urlString;
}

// Generates a string from an array of exclusions
- (NSString *)stringForExclusions:(NSArray *)exclusions
{
    __block NSString *exclusionString = @"";
    [exclusions enumerateObjectsUsingBlock:^(id exclusion, NSUInteger idx, BOOL *stop) {
        exclusionString = [exclusionString stringByAppendingFormat:idx == 0 ? @"%@" : @",%@", exclusion];
    }];
    return exclusionString;
}

# pragma mark - Cache Instance Methods

// Checks the NSUserDefaults for a cached forecast that is still fresh
- (void)checkForecastCacheForURLString:(NSString *)urlString
                               success:(void (^)(id cachedForecast))success
                               failure:(void (^)(NSError *error))failure
{
    if (self.cacheEnabled) {
        
        //  Perform this on a background thread
        dispatch_async(async_queue, ^{
            BOOL cachedItemWasFound = NO;
            @try {
                NSDictionary *cachedForecasts = [userDefaults dictionaryForKey:kFCCacheKey];
                if (cachedForecasts) {
                    // Create an NSString object from the coordinates as the dictionary key
                    NSData *archivedCacheItem = [cachedForecasts objectForKey:urlString];
                    // Check if the forecast exists and hasn't expired yet
                    if (archivedCacheItem) {
                        NSDictionary *cacheItem = [self objectForArchive:archivedCacheItem];
                        if (cacheItem) {
                            NSDate *expirationTime = (NSDate *)[cacheItem objectForKey:kFCCacheExpiresKey];
                            NSDate *rightNow = [NSDate date];
                            if ([rightNow compare:expirationTime] == NSOrderedAscending) {
#ifndef NDEBUG
                                NSLog(@"Forecastr: Found cached item for %@", urlString);
#endif
                                cachedItemWasFound = YES;
                                // Cache item is still fresh
                                dispatch_sync(dispatch_get_main_queue(), ^{
                                    success([cacheItem objectForKey:kFCCacheForecastKey]);
                                });
                                
                            }
                            // As a note, there is no need to remove any stale cache item since it will
                            // be overwritten when the forecast is cached again
                        }
                    }
                }
                if (!cachedItemWasFound) {
                    // If we don't have anything fresh in the cache
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        failure([NSError errorWithDomain:kFCErrorDomain code:kFCCachedItemNotFound userInfo:nil]);
                    });
                }
            }
            @catch (NSException *exception) {
#ifndef NDEBUG
                NSLog(@"Forecastr: Caught an exception while reading from cache (%@)", exception);
#endif
                dispatch_sync(dispatch_get_main_queue(), ^{
                    failure([NSError errorWithDomain:kFCErrorDomain code:kFCCachedItemNotFound userInfo:nil]);
                });
            }
        });
        
    } else {
        failure([NSError errorWithDomain:kFCErrorDomain code:kFCCacheNotEnabled userInfo:nil]);
    }
}

// Caches a forecast in NSUserDefaults based on the original URL string used to request it
- (void)cacheForecast:(id)forecast withURLString:(NSString *)urlString
{
#ifndef NDEBUG
    NSLog(@"Forecastr: Caching item for %@", urlString);
#endif
    
    // Save to cache on a background thread
    dispatch_async(async_queue, ^{
        NSMutableDictionary *cachedForecasts = [[userDefaults dictionaryForKey:kFCCacheKey] mutableCopy];
        if (!cachedForecasts) cachedForecasts = [[NSMutableDictionary alloc] initWithCapacity:1];
        
        // Set up the new dictionary we are going to cache
        NSDate *expirationDate = [[NSDate date] dateByAddingTimeInterval:self.cacheExpirationInMinutes * 60]; // X minutes from now
        NSMutableDictionary *newCacheItem = [[NSMutableDictionary alloc] initWithCapacity:2];
        [newCacheItem setObject:expirationDate forKey:kFCCacheExpiresKey];
        [newCacheItem setObject:forecast forKey:kFCCacheForecastKey];
        
        // Save the new cache item and sync the user defaults
        [cachedForecasts setObject:[self archivedObject:newCacheItem] forKey:urlString];
        [userDefaults setObject:cachedForecasts forKey:kFCCacheKey];
        [userDefaults synchronize];
    });
}

// Deprecated method
- (void)removeCachedForecastForLatitude:(double)lat longitude:(double)lon time:(NSNumber *)time exclusions:(NSArray *)exclusions extend:(NSString *)extendCommand
{
    [self removeCachedForecastForLatitude:lat longitude:lon time:time exclusions:exclusions extend:extendCommand language:nil];
}

// Removes a cached forecast in case you want to refresh it prematurely
- (void)removeCachedForecastForLatitude:(double)lat longitude:(double)lon time:(NSNumber *)time exclusions:(NSArray *)exclusions extend:(NSString *)extendCommand language:(NSString *)languageCode
{
    NSString *urlString = [self urlStringforLatitude:lat longitude:lon time:time exclusions:exclusions extend:extendCommand language:languageCode];
    NSString *cacheKey = [self cacheKeyForURLString:urlString forLatitude:lat longitude:lon];
    
    NSMutableDictionary *cachedForecasts = [[userDefaults dictionaryForKey:kFCCacheKey] mutableCopy];
    if (cachedForecasts) {
#ifndef NDEBUG
        NSLog(@"Forecastr: Removing cached item for %@", cacheKey);
#endif
        [cachedForecasts removeObjectForKey:cacheKey];
        [userDefaults setObject:cachedForecasts forKey:kFCCacheKey];
        [userDefaults synchronize];
    }
}

// Flushes all forecasts from the cache
- (void)flushCache
{
#ifndef NDEBUG
    NSLog(@"Forecastr: Flushing the cache...");
#endif
    [userDefaults removeObjectForKey:kFCCacheKey];
    [userDefaults synchronize];
}

# pragma mark - Cache Private Methods

// Truncates the latitude and longitude within the URL so that it's more generalized to the user's location
// Otherwise, you end up requesting forecasts from the server even though your lat/lon has only changed by a very small amount
- (NSString *)cacheKeyForURLString:(NSString *)urlString forLatitude:(double)lat longitude:(double)lon
{
    NSString *oldLatLon = [NSString stringWithFormat:@"%f,%f", lat, lon];
    NSString *generalizedLatLon = [NSString stringWithFormat:@"%.2f,%.2f", lat, lon];
    return [urlString stringByReplacingOccurrencesOfString:oldLatLon withString:generalizedLatLon];
}

// Creates an archived object suitable for storing in NSUserDefaults
- (NSData *)archivedObject:(id)object
{
    return object ? [NSKeyedArchiver archivedDataWithRootObject:object] : nil;
}

// Unarchives an object that was stored as NSData
- (id)objectForArchive:(NSData *)archivedObject
{
    return archivedObject ? [NSKeyedUnarchiver unarchiveObjectWithData:archivedObject] : nil;
}

#pragma mark - KVO Observing Methods

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
    NSArray *keyPaths = @[@"language",@"units"];
    if ([keyPaths containsObject:keyPath]) {
        // Check if the property has changed values. If so, the cache will need to be flushed to ensure incorrect data is not reported.
        id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
        id newValue = [change objectForKey:NSKeyValueChangeNewKey];
        BOOL flushCache = ![oldValue isEqual:newValue];
        
        if (flushCache) {
            [self flushCache];
        }
    }
}

@end
