//
//  Forecastr.h
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

#import <Foundation/Foundation.h>

// Updated to match the Forecast.io API as of December 20, 2013

#define IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

typedef enum {
    kFCUnitsModeUndefined = 0,
    kFCUnitsModeUS = 1,
    kFCUnitsModeSI = 2,
    kFCUnitsModeUK = 3,
    kFCUnitsModeCA = 4
} ForecastrUnitsMode;

// API Call Limit
extern NSString *const kFCAPICallLimitExceededWarning;
extern NSString *const kFCAPIRecentCallClearingCode;

// Cache keys
extern NSString *const kFCCacheKey;
extern NSString *const kFCCacheArchiveKey;
extern NSString *const kFCCacheExpiresKey;
extern NSString *const kFCCacheForecastKey;

// Unit types
extern NSString *const kFCUSUnits;
extern NSString *const kFCSIUnits;
extern NSString *const kFCUKUnits;
extern NSString *const kFCCAUnits;
extern NSString *const kFCAutoUnits;

// Languages
extern NSString *const kFCLanguageBosnian;
extern NSString *const kFCLanguageGerman;
extern NSString *const kFCLanguageEnglish;
extern NSString *const kFCLanguageSpanish;
extern NSString *const kFCLanguageFrench;
extern NSString *const kFCLanguageItalian;
extern NSString *const kFCLanguageDutch;
extern NSString *const kFCLanguagePolish;
extern NSString *const kFCLanguagePortuguese;
extern NSString *const kFCLanguageTetum;
extern NSString *const kFCLanguagePigLatin;

// Extend types
extern NSString *const kFCExtendHourly;

// Forecast names used for the data block hash keys
extern NSString *const kFCCurrentlyForecast;
extern NSString *const kFCMinutelyForecast;
extern NSString *const kFCHourlyForecast;
extern NSString *const kFCDailyForecast;

// Additional names used for the data block hash keys
extern NSString *const kFCAlerts;
extern NSString *const kFCFlags;
extern NSString *const kFCLatitude;
extern NSString *const kFCLongitude;
extern NSString *const kFCOffset;
extern NSString *const kFCTimezone;

// Names used for the data point hash keys
extern NSString *const kFCCloudCover;
extern NSString *const kFCCloudCoverError;
extern NSString *const kFCDewPoint;
extern NSString *const kFCHumidity;
extern NSString *const kFCHumidityError;
extern NSString *const kFCIcon;
extern NSString *const kFCMoonPhase;
extern NSString *const kFCOzone;
extern NSString *const kFCPrecipAccumulation;
extern NSString *const kFCPrecipIntensity;
extern NSString *const kFCPrecipIntensityMax;
extern NSString *const kFCPrecipIntensityMaxTime;
extern NSString *const kFCPrecipProbability;
extern NSString *const kFCPrecipType;
extern NSString *const kFCPressure;
extern NSString *const kFCPressureError;
extern NSString *const kFCSummary;
extern NSString *const kFCSunriseTime;
extern NSString *const kFCSunsetTime;
extern NSString *const kFCTemperature;
extern NSString *const kFCTemperatureMax;
extern NSString *const kFCTemperatureMaxError;
extern NSString *const kFCTemperatureMaxTime;
extern NSString *const kFCTemperatureMin;
extern NSString *const kFCTemperatureMinError;
extern NSString *const kFCTemperatureMinTime;
extern NSString *const kFCApparentTemperature;
extern NSString *const kFCTime;
extern NSString *const kFCVisibility;
extern NSString *const kFCVisibilityError;
extern NSString *const kFCWindBearing;
extern NSString *const kFCWindSpeed;
extern NSString *const kFCWindSpeedError;

// Names used for weather icons
extern NSString *const kFCIconClearDay;
extern NSString *const kFCIconClearNight;
extern NSString *const kFCIconRain;
extern NSString *const kFCIconSnow;
extern NSString *const kFCIconSleet;
extern NSString *const kFCIconWind;
extern NSString *const kFCIconFog;
extern NSString *const kFCIconCloudy;
extern NSString *const kFCIconPartlyCloudyDay;
extern NSString *const kFCIconPartlyCloudyNight;
extern NSString *const kFCIconHail;
extern NSString *const kFCIconThunderstorm;
extern NSString *const kFCIconTornado;
extern NSString *const kFCIconHurricane;

// A numerical value representing the distance to the nearest storm
extern NSString *const kFCNearestStormDistance;
extern NSString *const kFCNearestStormBearing;

@interface Forecastr : NSObject

@property (nonatomic, strong) NSString *apiKey;
@property (nonatomic, strong) NSString *units; // Defaults to 'us'
@property (nonatomic, strong) NSString *language; // Defaults to 'en'
@property (nonatomic, strong) NSString *callback;

@property (nonatomic, assign) BOOL cacheEnabled; // Defaults to YES
@property (nonatomic, assign) int cacheExpirationInMinutes; // Defaults to 30 mins

@property (nonatomic, assign) BOOL requestHTTPCompression; // Defaults to YES

/**
 * Initializes and returns a new Forecastr singleton object
 *
 * @return A new singleton object
 */

+ (id)sharedManager;


/**
 * Requests the forecast for the given location and optional time and/or exclusions
 *
 * @return The JSON response
 *
 * @param lat The latitude of the location.
 * @param long The longitude of the location.
 * @param time (Optional) The desired time of the forecast in UNIX GMT format
 * @param exclusions (Optional) An array which specifies which data blocks you would like left off the response
 * @param success A block object to be executed when the operation finishes successfully.
 * @param failure A block object to be executed when the operation finishes unsuccessfully.
 *
 * @discussion For many locations, it can be 60 years in the past to 10 years in the future.
 */

- (void)getForecastForLatitude:(double)lat
                     longitude:(double)lon
                          time:(NSNumber *)time
                    exclusions:(NSArray *)exclusions
                       success:(void (^)(id JSON))success
                       failure:(void (^)(NSError *error, id response))failure;

/**
 * Requests the forecast for the given location and optional time and/or exclusions
 *
 * @return The JSON response
 *
 * @param lat The latitude of the location.
 * @param long The longitude of the location.
 * @param time (Optional) The desired time of the forecast in UNIX GMT format
 * @param exclusions (Optional) An array which specifies which data blocks you would like left off the response
 * @param extend (Optional) Extra commands that are sent to the server
 * @param success A block object to be executed when the operation finishes successfully.
 * @param failure A block object to be executed when the operation finishes unsuccessfully.
 *
 * @discussion For many locations, it can be 60 years in the past to 10 years in the future.
 */

- (void)getForecastForLatitude:(double)lat
                     longitude:(double)lon
                          time:(NSNumber *)time
                    exclusions:(NSArray *)exclusions
                        extend:(NSString*)extendCommand
                       success:(void (^)(id JSON))success
                       failure:(void (^)(NSError *error, id response))failure;

/**
 * Requests the forecast for the given location and optional time and/or exclusions
 *
 * @return The JSON response
 *
 * @param lat The latitude of the location.
 * @param long The longitude of the location.
 * @param time (Optional) The desired time of the forecast in UNIX GMT format
 * @param exclusions (Optional) An array which specifies which data blocks you would like left off the response
 * @param extend (Optional) Extra commands that are sent to the server
 * @param language (Optional) Specify which language you want the weather descriptions in
 * @param success A block object to be executed when the operation finishes successfully.
 * @param failure A block object to be executed when the operation finishes unsuccessfully.
 *
 * @discussion For many locations, it can be 60 years in the past to 10 years in the future.
 */

- (void)getForecastForLatitude:(double)lat
                     longitude:(double)lon
                          time:(NSNumber *)time
                    exclusions:(NSArray *)exclusions
                        extend:(NSString *)extendCommand
                      language:(NSString *)languageCode
                       success:(void (^)(id JSON))success
                       failure:(void (^)(NSError *error, id response))failure;


/**
 * Cancels all requests that are currently being executed
 */
- (void)cancelAllForecastRequests;

/**
 * Returns a description based on the precicipation intensity
 *
 * @param precipIntensity The precipIntensity for the acquired forecast data
 */
- (NSString *)descriptionForPrecipIntensity:(float)precipIntensity;

/**
 * Returns a description based on the cloud cover percentage
 *
 * @param cloudCover The cloudCover percentage for the acquired forecast data
 */
- (NSString *)descriptionForCloudCoverPercentage:(float)cloudCover;

/**
 * Returns an image name based on the weather icon type
 *
 * @param iconDescription The description of the weather icon for the acquired forecast data
 */
- (NSString *)imageNameForWeatherIconType:(NSString *)iconDescription;

/**
 * Checks the NSUserDefaults for a cached forecast that is still fresh
 * This will save us round trips and usage for the Forecast.io servers
 * self.cacheEnabled is YES by default, but you can disable it for testing or if you don't want to use it
 *
 * @return The JSON or JSONP response if found and still fresh, otherwise an NSError (that you can ignore) 
 *
 * @param forecast The returned JSON or JSONP for the forecast you wish to cache
 * @param urlString The original URL string used to make the request (this assumes your API key doesn't change)
 */
- (void)checkForecastCacheForURLString:(NSString *)urlString
                               success:(void (^)(id cachedForecast))success
                               failure:(void (^)(NSError *error))failure;

/**
 * Caches a forecast, on a background thread, in NSUserDefaults based on the original URL string used to request it
 *
 * @param forecast The returned JSON or JSONP for the forecast you wish to cache
 * @param urlString The original URL string used to make the request (this assumes your API key doesn't change)
 */
- (void)cacheForecast:(id)forecast withURLString:(NSString *)urlString;

/**
 * Removes a cached forecast in case you want to refresh it prematurely
 * Make sure you pass in the exact same params that you used in the original request
 *
 * @param lat The latitude of the location.
 * @param long The longitude of the location.
 * @param time (Optional) The desired time of the forecast in UNIX GMT format
 * @param exclusions (Optional) An array which specifies which data blocks you would like left off the response
 * @param extend (Optional) Extra commands that are sent to the server
 */
- (void)removeCachedForecastForLatitude:(double)lat
                              longitude:(double)lon
                                   time:(NSNumber *)time
                             exclusions:(NSArray *)exclusions
                                 extend:(NSString *)extendCommand DEPRECATED_ATTRIBUTE;

/**
 * Removes a cached forecast in case you want to refresh it prematurely
 * Make sure you pass in the exact same params that you used in the original request
 *
 * @param lat The latitude of the location.
 * @param long The longitude of the location.
 * @param time (Optional) The desired time of the forecast in UNIX GMT format
 * @param exclusions (Optional) An array which specifies which data blocks you would like left off the response
 * @param extend (Optional) Extra commands that are sent to the server
 * @param language (Optional) Specify which language you want the weather descriptions in
 */
- (void)removeCachedForecastForLatitude:(double)lat
                              longitude:(double)lon
                                   time:(NSNumber *)time
                             exclusions:(NSArray *)exclusions
                                 extend:(NSString *)extendCommand
                               language:(NSString *)languageCode;


/**
 * Flushes all forecasts from the cache
 */
- (void)flushCache;


-(NSString *)messageForSettingsAlertViewRequestingAPICallTrackingCacheReset;
-(BOOL)allowAPICallTrackingCacheResetWithSecurityCode:(NSString *)securityCode;

@end
