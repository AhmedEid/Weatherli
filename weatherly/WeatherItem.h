//
//  WeatherItem.h
//  Weatherli
//
//  Created by Ahmed Eid on 5/14/12.
//  Copyright (c) 2012 Ahmed Eid. All rights reserved.
//  This file is part of Weatherli.
//
//  Weatherli is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  Weatherli is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with Weatherli.  If not, see <http://www.gnu.org/licenses/>.
//

#import <Foundation/Foundation.h>

@interface WeatherItem : NSObject <NSCoding>

@property (nonatomic) int indexForWeatherMap;
@property (nonatomic, strong) NSString *weatherCurrentTemp;
@property (nonatomic, strong) NSArray *nextDays;

@property (nonatomic, strong) UIImage *weatherCurrentTempImage;
@property (nonatomic, strong) NSString *weatherCurrentDay;
@property (nonatomic, strong) NSArray *weatherForecast;
@property (nonatomic, strong) NSArray *weatherForecastConditions;
@property (nonatomic, strong) NSArray *weatherForecastConditionsImages;

@property (nonatomic, strong) NSString *weatherCode;
@property (nonatomic, strong) NSString *weatherPrecipitationAmount;
@property (nonatomic, strong) NSString *weatherHumidity;
@property (nonatomic, strong) NSString *weatherWindSpeed;

-(id)initWithCurrentTemp:(NSString *)currentTemp currentDay:(NSString *)currentDay Forecast:(NSArray *)forecast andForecastConditions:(NSArray *)forecastConditions;

@end
