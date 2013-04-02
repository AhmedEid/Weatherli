//
//  DetailView.h
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
#import "WeatherManager.h"
#import "WeatherItem.h"

@interface DetailView : UIView

@property (weak, nonatomic) IBOutlet UILabel *dayLabel1;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel2;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel3;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel4;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel5;
@property (weak, nonatomic) IBOutlet UIImageView *dayImage1;
@property (weak, nonatomic) IBOutlet UIImageView *dayImage2;
@property (weak, nonatomic) IBOutlet UIImageView *dayImage3;
@property (weak, nonatomic) IBOutlet UILabel *designedByLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dayImage4;
@property (weak, nonatomic) IBOutlet UIImageView *dayImage5;
@property (weak, nonatomic) IBOutlet UILabel *dayTemp1;
@property (weak, nonatomic) IBOutlet UILabel *dayTemp2;
@property (weak, nonatomic) IBOutlet UILabel *dayTemp3;
@property (weak, nonatomic) IBOutlet UILabel *dayTemp4;
@property (weak, nonatomic) IBOutlet UILabel *dayTemp5;
@property (weak, nonatomic) IBOutlet UILabel *madeWithLoveLabel;

@property (nonatomic, strong) WeatherItem *item;

-(id)initWithWeatherItem:(WeatherItem *)item andframe:(CGRect )frame;

@end
