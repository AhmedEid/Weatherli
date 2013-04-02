//
//  DetailView.m
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
#import "DetailView.h"

@implementation DetailView

@synthesize dayLabel1 = _dayLabel1;
@synthesize dayLabel2 = _dayLabel2;
@synthesize dayLabel3 = _dayLabel3;
@synthesize dayLabel4 = _dayLabel4;
@synthesize dayLabel5 = _dayLabel5;
@synthesize dayImage1 = _dayImage1;
@synthesize dayImage2 = _dayImage2;
@synthesize dayImage3 = _dayImage3;
@synthesize designedByLabel = _designedByLabel;
@synthesize dayImage4 = _dayImage4;
@synthesize dayImage5 = _dayImage5;
@synthesize dayTemp1 = _dayTemp1;
@synthesize dayTemp2 = _dayTemp2;
@synthesize dayTemp3 = _dayTemp3;
@synthesize dayTemp4 = _dayTemp4;
@synthesize dayTemp5 = _dayTemp5;
@synthesize madeWithLoveLabel = _madeWithLoveLabel;
@synthesize item = _item;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"DetailView"
                                                              owner:nil
                                                            options:nil];
        if ([arrayOfViews count] < 1) return nil;

        DetailView *newView = [arrayOfViews objectAtIndex:0];
        [newView setFrame:frame];
        self = newView;
    }
    return self;
}

-(id)initWithWeatherItem:(WeatherItem *)item andframe:(CGRect )frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Init code here
        self.item = item;
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

@end
