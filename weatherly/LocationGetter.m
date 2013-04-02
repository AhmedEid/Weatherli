//
//  LocationGetter.m
//  CoreLocationExample
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

#import "LocationGetter.h"

@interface LocationGetter ()
{
    CLLocationManager *locationManager;
    BOOL didUpdate;
}
@end

@implementation LocationGetter

@synthesize delegate = _delegate;

- (id)init {
    if (self = [super init]) {
        // Init code here
        didUpdate = NO;
    }
    return self;
}

- (void)startUpdates
{    
    if (locationManager == nil)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    
    // You have some options here, though higher accuracy takes longer to resolve.
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;  
    [locationManager startUpdatingLocation];    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your location could not be determined. Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];     
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manage didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
        if (didUpdate) return;
    
        didUpdate = YES;
    
        // Disable future updates to save power.
        [locationManager stopUpdatingLocation];
	        
        // let our delegate know we're done
        [self.delegate newPhysicalLocation:newLocation];
}

@end
