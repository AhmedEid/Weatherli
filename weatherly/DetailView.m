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
@synthesize dayLabel1;
@synthesize dayLabel2;
@synthesize dayLabel3;
@synthesize dayLabel4;
@synthesize dayLabel5;
@synthesize dayImage1;
@synthesize dayImage2;
@synthesize dayImage3;
@synthesize designedByLabel;
@synthesize dayImage4;
@synthesize dayImage5;
@synthesize dayTemp1;
@synthesize dayTemp2;
@synthesize dayTemp3;
@synthesize dayTemp4;
@synthesize dayTemp5;
@synthesize madeWithLoveLabel;
@synthesize item = _item;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"DetailView"
                                                              owner:nil
                                                            options:nil];
        if ([arrayOfViews count] < 1){
            return nil;
        }
        
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
        // 
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"DetailView"
                                                              owner:nil
                                                            options:nil];
        if ([arrayOfViews count] < 1){
            return nil;
        }
        
        DetailView *newView = [arrayOfViews objectAtIndex:0];
        [newView setFrame:frame];
        
        self = newView;
        self.item = item;
        
    }
    return self;

}

-(void)layoutSubviews
{
    [super layoutSubviews];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
