//
//  LocationGetter.m
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


#import "LocationManager.h"

@interface LocationManager ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL didUpdate;

@end

@implementation LocationManager

# pragma mark - Singleton Methods

+ (id)sharedManager {
    static LocationManager *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (id)init {
    if (self = [super init]) {
        self.didUpdate = NO;
    }
    return self;
}

- (void)startUpdates {
    if (!self.locationManager) {
        self.locationManager = [CLLocationManager new];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    }
  
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your location could not be determined. Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];     
}

- (void)locationManager:(CLLocationManager *)manage didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
        if (self.didUpdate) return;
    
        self.didUpdate = YES;
    
        // Disable future updates to save power.
        [self.locationManager stopUpdatingLocation];
	        
        [self.delegate didLocateNewUserLocation:newLocation];
}

@end
