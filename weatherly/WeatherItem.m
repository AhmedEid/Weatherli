//
//  WeatherItem.m
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
#import "WeatherItem.h"

@implementation WeatherItem
@synthesize weatherCurrentTemp = _weatherCurrentTemp;
@synthesize weatherForecast = _weatherForecast;
@synthesize weatherCurrentDay = _weatherCurrentDay;
@synthesize weatherForecastConditions = _weatherForecastConditions;
@synthesize indexForWeatherMap;
@synthesize weatherCode = _weatherCode;
@synthesize weatherPrecipitationAmount = _weatherPrecipitationAmount;
@synthesize weatherWindSpeed = _weatherWindSpeed;
@synthesize weatherHumidity = _weatherHumidity;
@synthesize weatherForecastConditionsImages = _weatherForecastConditionsImages;
@synthesize weatherCurrentTempImage = _weatherCurrentTempImage;
@synthesize nextDays = _nextDays;

-(id)initWithCurrentTemp:(NSString *)currentTemp currentDay:(NSString *)currentDay Forecast:(NSArray *)forecast andForecastConditions:(NSArray *)forecastConditions;
{
    self = [super init];
    if (self)
    {
        self.weatherCurrentTemp = currentTemp;
        self.weatherCurrentDay = currentDay;
        self.weatherForecast = forecast;
        self.weatherForecastConditions = forecastConditions;
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.weatherCode forKey:@"weatherCode"];
    [encoder encodeObject:[NSNumber numberWithUnsignedInteger:indexForWeatherMap] forKey:@"indexForWeatherMap"];
    [encoder encodeObject:self.weatherCurrentDay forKey:@"weatherCurrentDay"];
    [encoder encodeObject:self.weatherCurrentTemp forKey:@"weatherCurrentTemp"];
    [encoder encodeObject:self.weatherCurrentTempImage forKey:@"weatherCurrentTempImage"];
    [encoder encodeObject:self.weatherForecast forKey:@"weatherForecast"];
    [encoder encodeObject:self.weatherForecastConditions forKey:@"weatherForecastConditions"];
    [encoder encodeObject:self.weatherForecastConditionsImages forKey:@"weatherForecastConditionsImages"];
    [encoder encodeObject:self.weatherHumidity forKey:@"weatherHumidity"];
    [encoder encodeObject:self.weatherPrecipitationAmount forKey:@"weatherPrecipitationAmount"];
    [encoder encodeObject:self.weatherWindSpeed forKey:@"weatherWindSpeed"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self.weatherCode = [decoder decodeObjectForKey:@"weatherCode"];
    indexForWeatherMap = [[decoder decodeObjectForKey:@"indexForWeatherMap"] unsignedIntegerValue];
    self.weatherCurrentDay = [decoder decodeObjectForKey:@"weatherCurrentDay"];
    self.weatherCurrentTemp = [decoder decodeObjectForKey:@"weatherCurrentTemp"];
    self.weatherCurrentTempImage = [decoder decodeObjectForKey:@"weatherCurrentTempImage"];
    self.weatherForecast = [decoder decodeObjectForKey:@"weatherForecast"];
    self.weatherForecastConditions = [decoder decodeObjectForKey:@"weatherForecastConditions"];
    self.weatherForecastConditionsImages = [decoder decodeObjectForKey:@"weatherForecastConditionsImages"];
    self.weatherHumidity = [decoder decodeObjectForKey:@"weatherHumidity"];
    self.weatherPrecipitationAmount = [decoder decodeObjectForKey:@"weatherPrecipitationAmount"];
    self.weatherWindSpeed = [decoder decodeObjectForKey:@"weatherWindSpeed"];

    return self;
}

@end