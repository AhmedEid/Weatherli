//
//  WeatherManager.m
//  weatherly
//
//  Created by Ahmed Eid on 5/14/12.
//  Copyright (c) 2012 Ahmed Eid. All rights reserved.
//This file is part of Weatherli.
//
//Weatherli is free software: you can redistribute it and/or modify
//it under the terms of the GNU General Public License as published by
//the Free Software Foundation, either version 3 of the License, or
//(at your option) any later version.
//
//Foobar is distributed in the hope that it will be useful,
//but WITHOUT ANY WARRANTY; without even the implied warranty of
//MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//GNU General Public License for more details.
//
//You should have received a copy of the GNU General Public License
//along with Weatherli.  If not, see <http://www.gnu.org/licenses/>.
//
#import "WeatherManager.h"

WeatherManager *sharedWeatherManager = nil;

@implementation WeatherManager
@synthesize locationGetter = _locationGetter;
@synthesize delegate = _delegate;
@synthesize internetActive, hostActive;
@synthesize internetConnectionTimer = _internetConnectionTimer;

#pragma mark - Singleton Stuff

+(WeatherManager *)sharedWeatherManager
{
    if (sharedWeatherManager ==nil)
    {
        sharedWeatherManager = [[super allocWithZone:NULL] init];
    }
    return sharedWeatherManager;
}

- (id)init
{
    self = [super init];
    
    if (self) {
    }
    return self;
}

// We don't want to allocate a new instance, so return the current one.
+ (id)allocWithZone:(NSZone*)zone {
    return [self sharedWeatherManager];
}

// Equally, we don't want to generate multiple copies of the singleton.
- (id)copyWithZone:(NSZone *)zone {
    return self;
}

-(void)startUpdatingLocation
{
    self.locationGetter = [[LocationGetter alloc] init];
    self.locationGetter.delegate = self;
    [self.locationGetter startUpdates]; 
}

-(WeatherItem *)currentWeatherItem
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"currentItem"];
    WeatherItem *item = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if (!data)
    {
        NSArray *forecast = [NSArray arrayWithObjects:@"66",@"76",@"56",@"94",@"32", nil];
        
        NSArray *forecastConditions = [NSArray arrayWithObjects:@"Sunny",@"Rainy",@"Sunny",@"Cloudy",@"Heavy Rain", nil];
        
        WeatherItem *defaultItem = [[WeatherItem alloc] initWithCurrentTemp:@"100" currentDay:@"Mon" Forecast:forecast andForecastConditions:forecastConditions];
        item.indexForWeatherMap = [self indexForTemperature:item.weatherCurrentTemp];
        item.weatherWindSpeed = @"5";
        item.weatherCode = @"116";
        item.weatherCurrentTempImage = [UIImage imageNamed:@"sun.png"];
        item.weatherHumidity = @"50";
        item.weatherPrecipitationAmount = @"0";
        
        UIImage *sun = [UIImage imageNamed:@"sun.png"];
        item.weatherForecastConditionsImages = [NSArray arrayWithObjects: sun, sun, sun, sun, sun, nil];
        
        [self startUpdatingLocation];
        
        return defaultItem;
    } else {
        return item;
    }
}

#pragma mark LocationDelegateMethods 

- (void) newPhysicalLocation:(CLLocation *)location;
{   
    //Get the zipcode using CLGeocoder
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:
    ^(NSArray *placemarks, NSError *error) {
        if (placemarks)
        {
            MKPlacemark *placemark = [placemarks objectAtIndex:0];
            
            NSString *zip = [placemark.addressDictionary objectForKey:@"ZIP"];

            NSString *queryString = [NSString stringWithFormat:@"http://free.worldweatheronline.com/feed/weather.ashx?q=%@&format=json&num_of_days=5&key=c0901b281c095607121605", zip];
            
            
            [self executeFetchForQueryString:queryString];
        } else if (error)
        {
            NSLog(@"Error getting zipcode from geocoder: %@", error.localizedDescription);
        }
    }];
}

#pragma mark Newtorking Methods 

-(void)executeFetchForQueryString:(NSString *)queryString
{    
    queryString = [queryString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //Create JSONData using the string 
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:queryString] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    
    //Results from JSON Data 
    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:jsonData 
                                                            options:kNilOptions
                                                              error:&error];    
    WeatherItem *item = [WeatherItem itemFromWeatherDictionary:results];
    if (self.delegate)
    {        
        //Save in NSUserDefaults
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:item];
        [defaults setObject:data forKey:@"currentItem"];
        
        [self.delegate didRecieveAndParseNewWeatherItem:item];
    }
}
                               
                               
 //TO BE DELETED                               
-(int)indexForTemperature:(NSString *)temp
    {
        int temperatureInt = temp.intValue;
        
        if (temperatureInt <=8 && temperatureInt >=0)
        {
            return 12;
        } else if (temperatureInt <=17 && temperatureInt >=9)
        {
            return 11;
        } else if (temperatureInt <=26 && temperatureInt >=18)
        {
            return 10;
        } else if (temperatureInt <=35 && temperatureInt >=27)
        {
            return 9;
        } else if (temperatureInt <=44 && temperatureInt >=36)
        {
            return 8;
        } else if (temperatureInt <=53 && temperatureInt >=45)
        {
            return 7;
        } else if (temperatureInt <=62 && temperatureInt >=54)
        {
            return 6;
        } else if (temperatureInt <=71 && temperatureInt >=63)
        {
            return 5;
        } else if (temperatureInt <=80 && temperatureInt >=72)
        {
            return 4;
        } else if (temperatureInt <=89 && temperatureInt >=81)
        {
            return 3;
        } else if (temperatureInt <=97 && temperatureInt >=90)
        {
            return 2;
        } else if (temperatureInt <=100 && temperatureInt >=98)
        {
            return 1;
        } else if (temperatureInt <=200 && temperatureInt >=101)
        {
            return 0;
        }
        return 0;
    }                      


@end
