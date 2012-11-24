//
//  WeatherViewController.h
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

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "DetailView.h"
#import "DrawerView.h"
#import "SoundManager.h"

@interface WeatherViewController : UIViewController <UIScrollViewDelegate, UIGestureRecognizerDelegate, WeatherManagerDelegate >

@property (nonatomic) int indexOfCurrentTempString;
@property (nonatomic, strong) NSArray *colorsArray;

@property (nonatomic, strong) NSMutableArray *topSmallRectangleViews;
@property (nonatomic, strong) NSMutableArray *bottomSmallRectangleViews;

@property (nonatomic) BOOL open;
@property (nonatomic) BOOL soundsEnabled;
@property (nonatomic) BOOL isChangingIndex;

@property (nonatomic, strong) WeatherItem *currentWeatherItem;

//Views 
@property (nonatomic, strong) UILabel *currentTempLabel;
@property (nonatomic, strong) UIScrollView *largeRectangleScrollView;
@property (nonatomic, strong) DetailView *detailView;
@property (nonatomic, strong) DrawerView *drawerView;

@property (nonatomic, strong) UIButton *infoButton;

@end