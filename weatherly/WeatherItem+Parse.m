//
//  WeatherItem+Parse.m
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


#import "WeatherItem+Parse.h"

@implementation WeatherItem (Parse)

+(WeatherItem *)itemFromWeatherDictionary:(NSDictionary *)dict {
    WeatherItem *item = nil;
    
    item = [[WeatherItem alloc] init];
    
    NSDictionary *data = [dict objectForKey:@"data"];
    NSArray *currentConditions = [data objectForKey:@"current_condition"];
    NSDictionary *currentConditionsDict = [currentConditions objectAtIndex:0];
    item.weatherCurrentTemp = [currentConditionsDict objectForKey:@"temp_F"];
    item.weatherCode = [currentConditionsDict objectForKey:@"weatherCode"];
    item.weatherPrecipitationAmount = [currentConditionsDict objectForKey:@"precipMM"];
    item.weatherHumidity = [currentConditionsDict objectForKey:@"humidity"];
    item.weatherWindSpeed = [currentConditionsDict objectForKey:@"windspeedMiles"];
    item.weatherCurrentTempImage = [self imageForWeatherCode:item.weatherCode];
        
    NSDictionary *forecast = [data objectForKey:@"weather"];
    
    NSMutableArray *mutableForecastArray = [NSMutableArray array];
    NSMutableArray *mutableForecastDescriptionArray = [NSMutableArray array];
    NSMutableArray *mutableForecasttDescriptionImages = [NSMutableArray array];
    NSMutableArray *mutableNextDaysArray = [NSMutableArray array];
    
    NSInteger i = 0;

    for (NSDictionary *dict in forecast) {
        NSString *day = [self dayNameFromDateString:[dict objectForKey:@"date"]];
        [mutableNextDaysArray insertObject:day atIndex:i];

        NSString *dayTemp = [dict objectForKey:@"tempMaxF"];
        NSArray *descriptionArray = [dict objectForKey:@"weatherDesc"];
        
        NSString *weatherCode = [dict objectForKey:@"weatherCode"];
        UIImage *image = [self imageForWeatherCode:weatherCode];
        
        NSDictionary *descriptionDict = [descriptionArray objectAtIndex:0];
        NSString *dayDescription = [descriptionDict objectForKey:@"value"];
        
        [mutableForecastArray insertObject:dayTemp atIndex:i]; 
        [mutableForecastDescriptionArray insertObject:dayDescription atIndex:i];
        [mutableForecasttDescriptionImages insertObject:image atIndex:i];
        NSLog(@"setting object %@ for key %@", dayTemp, day);

        i++;
    }
    item.weatherForecast = (NSArray *)mutableForecastArray;
    item.weatherForecastConditions = (NSArray *)mutableForecastDescriptionArray;
    item.weatherForecastConditionsImages = (NSArray *)mutableForecasttDescriptionImages;
    item.nextDays = (NSArray *)mutableNextDaysArray;
    
    NSLog (@"%@, %@, %@, %@", item.weatherForecast, item.weatherForecastConditionsImages, item.weatherForecastConditions, item.nextDays);
    
    item.indexForWeatherMap = [self indexForTemperature:item.weatherCurrentTemp];
    return item;
}

+ (NSString *)dayNameFromDateString:(NSString *)dateString {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormat dateFromString:dateString];  
    
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comp = [cal components:NSWeekdayCalendarUnit fromDate:date];
    if (comp.weekday ==1) {
        return @"Mon";
    } else if (comp.weekday ==2) {
        return @"Tue";
    } else if (comp.weekday ==3) {
        return @"Wed";
    } else if (comp.weekday ==4) {
        return @"Thu";
    } else if (comp.weekday ==5) {
        return @"Fri";
    } else if (comp.weekday ==6) {
        return @"Sat";
    } else if (comp.weekday ==7) {
        return @"Sun";
    } 
    return nil;
}


+ (int)indexForTemperature:(NSString *)temp {
    int temperatureInt = temp.intValue;
    
    if (temperatureInt <=8 && temperatureInt >=0) {
        return 12;
    } else if (temperatureInt <=17 && temperatureInt >=9) {
        return 11;
    } else if (temperatureInt <=26 && temperatureInt >=18) {
        return 10;
    } else if (temperatureInt <=35 && temperatureInt >=27) {
        return 9;
    } else if (temperatureInt <=44 && temperatureInt >=36) {
        return 8;
    } else if (temperatureInt <=53 && temperatureInt >=45) {
        return 7;
    } else if (temperatureInt <=62 && temperatureInt >=54) {
        return 6;
    } else if (temperatureInt <=71 && temperatureInt >=63) {
        return 5;
    } else if (temperatureInt <=80 && temperatureInt >=72) {
        return 4;
    } else if (temperatureInt <=89 && temperatureInt >=81) {
        return 3;
    } else if (temperatureInt <=97 && temperatureInt >=90) {
        return 2;
    } else if (temperatureInt <=100 && temperatureInt >=98) {
        return 1;
    } else if (temperatureInt <=200 && temperatureInt >=101) {
        return 0;
    }
    return 0;
}

+ (NSString *)descriptionOfWeatherFromWeatherCode:(NSString *)weatherCode {
    NSString *weatherDescription;
    
    switch (weatherCode.intValue) {
        case 113:
            weatherDescription = @"Clear/Sunny";
            break;
        case 116:
            weatherDescription = @"Partly Cloudy";
            break;
        case 119:
            weatherDescription = @"Cloudy";
            break;
        case 122:
            weatherDescription = @"Overcast";
            break;
        case 143:
            weatherDescription = @"Mist";
            break;
        case 176:
            weatherDescription = @"Patchy rain nearby";
            break;
        case 179:
            weatherDescription = @"Patchy snow nearby";
            break;
        case 182:
            weatherDescription = @"Patchy sleet nearby";
            break;
        case 185:
            weatherDescription = @"Patchy freezing drizzle nearby";
            break;
        case 200:
            weatherDescription = @"Thundery outbreaks in nearby";
            break;
        case 227:
            weatherDescription = @"Blowing snow";
            break;
        case 230:
            weatherDescription = @"Blizzard";
            break;
        case 248:
            weatherDescription = @"Fog";
            break;
        case 260:
            weatherDescription = @"Freezing fog";
            break;
        case 263:
            weatherDescription = @"Patchy light drizzle";
            break;
        case 266:
            weatherDescription = @"Light drizzle";
            break;
        case 281:
            weatherDescription = @"Freezing drizzle";
            break;
        case 284:
            weatherDescription = @"Heavy freezing drizzle";
            break;
        case 293:
            weatherDescription = @"Patchy light rain";
            break;
        case 296:
            weatherDescription = @"Light rain";
            break;
        case 299:
            weatherDescription = @"Moderate rain at times";
            break;
        case 302:
            weatherDescription = @"Moderate rain";
            break;
        case 305:
            weatherDescription = @"Heavy rain at times";
            break;
        case 308:
            weatherDescription = @"Heavy rain";
            break;
        case 311:
            weatherDescription = @"Light freezing rain";
            break;
        case 314:
            weatherDescription = @"Moderate or Heavy freezing rain";
            break;
        case 317:
            weatherDescription = @"Light sleet";
            break;
        case 320:
            weatherDescription = @"Moderate or heavy sleet";
            break;
        case 323:
            weatherDescription = @"Patchy light snow";
            break;
        case 326:
            weatherDescription = @"Light snow";
            break;
        case 329:
            weatherDescription = @"Patchy moderate snow";
            break;
        case 332:
            weatherDescription = @"Moderate snow";
            break;
        case 335:
            weatherDescription = @"Patchy heavy snow";
            break;
        case 338:
            weatherDescription = @"Heavy snow";
            break;
        case 350:
            weatherDescription = @"Ice pellets";
            break;
        case 353:
            weatherDescription = @"Light rain shower";
            break;
        case 356:
            weatherDescription = @"Moderate or heavy rain shower";
            break;
        case 359:
            weatherDescription = @"Torrential rain shower";
            break;
        case 362:
            weatherDescription = @"Light sleet showers";
            break;
        case 365:
            weatherDescription = @"Moderate or heavy sleet showers";
            break;
        case 368:
            weatherDescription = @"Light snow showers";
            break;
        case 371:
            weatherDescription = @"Moderate or heavy snow showers";
            break;
        case 374:
            weatherDescription = @"Light showers of ice pellets";
            break;
        case 377:
            weatherDescription = @"Moderate or heavy showers of ice pellets";
            break;
        case 386:
            weatherDescription = @"Patchy light rain in area with thunder";
            break;
        case 389:
            weatherDescription = @"Moderate or heavy rain in area with thunder";
            break;
        case 392:
            weatherDescription = @"Patchy light snow in area with thunder";
            break;
        case 395:
            weatherDescription = @"Moderate or heavy snow in area with thunder";
            break;
        default:
            break;
    }
    return weatherDescription;
}

+ (UIImage *)imageForWeatherCode:(NSString *)weatherCode {
    UIImage *weatherImage = [[UIImage alloc] init];
    
    switch (weatherCode.intValue) {
        case 113:
            weatherImage = [UIImage imageNamed:@"sun.png"];
            break;
        case 116:
            weatherImage = [UIImage imageNamed:@"cloud.png"];
            break;
        case 119:
            weatherImage = [UIImage imageNamed:@"cloud.png"];
            break;
        case 122:
            weatherImage = [UIImage imageNamed:@"cloud.png"];
            break;
        case 143:
            weatherImage = [UIImage imageNamed:@"fog.png"];
            break;
        case 176:
            weatherImage = [UIImage imageNamed:@"drizzle.png"];
            break;
        case 179:
            weatherImage = [UIImage imageNamed:@"snow.png"];
            break;
        case 182:
            weatherImage = [UIImage imageNamed:@"hail.png"];
            break;
        case 185:
            weatherImage = [UIImage imageNamed:@"drizzle.png"];
            break;
        case 200:
            weatherImage = [UIImage imageNamed:@"lightning.png"];
            break;
        case 227:
            weatherImage = [UIImage imageNamed:@"snow.png"];
            break;
        case 230:
            weatherImage = [UIImage imageNamed:@"snowAlt.png"];
            break;
        case 248:
            weatherImage = [UIImage imageNamed:@"fog.png"];
            break;
        case 260:
            weatherImage = [UIImage imageNamed:@"fog.png"];
            break;
        case 263:
            weatherImage = [UIImage imageNamed:@"drizzle.png"];
            break;
        case 266:
            weatherImage = [UIImage imageNamed:@"drizzle.png"];
            break;
        case 281:
            weatherImage = [UIImage imageNamed:@"drizzle.png"];
            break;
        case 284:
            weatherImage = [UIImage imageNamed:@"drizzle.png"];
            break;
        case 293:
            weatherImage = [UIImage imageNamed:@"rain.png"];
            break;
        case 296:
            weatherImage = [UIImage imageNamed:@"rain.png"];
            break;
        case 299:
            weatherImage = [UIImage imageNamed:@"rain.png"];
            break;
        case 302:
            weatherImage = [UIImage imageNamed:@"rain.png"];
            break;
        case 305:
            weatherImage = [UIImage imageNamed:@"rain.png"];
            break;
        case 308:
            weatherImage = [UIImage imageNamed:@"rain.png"];
            break;
        case 311:
            weatherImage = [UIImage imageNamed:@"rain.png"];
            break;
        case 314:
            weatherImage = [UIImage imageNamed:@"rain.png"];
            break;
        case 317:
            weatherImage = [UIImage imageNamed:@"hail.png"];
            break;
        case 320:
            weatherImage = [UIImage imageNamed:@"hail.png"];
            break;
        case 323:
            weatherImage = [UIImage imageNamed:@"snowAlt.png"];
            break;
        case 326:
            weatherImage = [UIImage imageNamed:@"snowAlt.png"];
            break;
        case 329:
            weatherImage = [UIImage imageNamed:@"snowAlt.png"];
            break;
        case 332:
            weatherImage = [UIImage imageNamed:@"snow.png"];
            break;
        case 335:
            weatherImage = [UIImage imageNamed:@"snow.png"];
            break;
        case 338:
            weatherImage = [UIImage imageNamed:@"snow.png"];
            break;
        case 350:
            weatherImage = [UIImage imageNamed:@"snow.png"];
            break;
        case 353:
            weatherImage = [UIImage imageNamed:@"rain.png"];
            break;
        case 356:
            weatherImage = [UIImage imageNamed:@"rain.png"];
            break;
        case 359:
            weatherImage = [UIImage imageNamed:@"rain.png"];
            break;
        case 362:
            weatherImage = [UIImage imageNamed:@"rain.png"];
            break;
        case 365:
            weatherImage = [UIImage imageNamed:@"rain.png"];
            break;
        case 368:
            weatherImage = [UIImage imageNamed:@"snow.png"];
            break;
        case 371:
            weatherImage = [UIImage imageNamed:@"snow.png"];
            break;
        case 374:
            weatherImage = [UIImage imageNamed:@"snow.png"];
            break;
        case 377:
            weatherImage = [UIImage imageNamed:@"snow.png"];
            break;
        case 386:
            weatherImage = [UIImage imageNamed:@"lightning.png"];
            break;
        case 389:
            weatherImage = [UIImage imageNamed:@"lightning.png"];
            break;
        case 392:
            weatherImage = [UIImage imageNamed:@"lightning.png"];
            break;
        case 395:
            weatherImage = [UIImage imageNamed:@"lightning.png"];
            break;
        default:
            break;
    }
    return weatherImage;
}

@end
