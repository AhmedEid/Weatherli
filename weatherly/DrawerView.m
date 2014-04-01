//
//  DrawerView.m
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


#import "DrawerView.h"

CGFloat  kFontSizeForDrawerViewLabels = 30;

@implementation DrawerView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"DrawerView"
                                                              owner:nil
                                                            options:nil];
        if ([arrayOfViews count] < 1) return nil;
        
        DrawerView *newView = [arrayOfViews objectAtIndex:0];
        [newView setFrame:frame];
        self = newView;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.humidityLabel.font = [UIFont fontWithName:@"steelfish" size:kFontSizeForDrawerViewLabels];
    self.precipitationLabel.font = [UIFont fontWithName:@"steelfish" size:kFontSizeForDrawerViewLabels];
    self.windLabel.font = [UIFont fontWithName:@"steelfish" size:kFontSizeForDrawerViewLabels];
    self.currentTempLabel.font = [UIFont fontWithName:@"steelfish" size:140];
    
    self.currentTempLabel.text = @"100°";
    self.currentTempLabel.backgroundColor = [UIColor clearColor];
    self.currentTempLabel.textColor = [UIColor whiteColor];
    [self.currentTempImageView setImage:[UIImage imageNamed:@"sun.png"]];


}

@end
