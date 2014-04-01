//
//  DetailView.m
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

#import "DetailView.h"

CGFloat  kFontSizeForDetailViewTitleLabels = 30;
CGFloat  kFontSizeForDetailViewTempLabel = 35;

@implementation DetailView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
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

- (void)awakeFromNib {
    [super awakeFromNib];
    self.dayLabel1.font = [UIFont fontWithName:@"steelfish" size:kFontSizeForDetailViewTitleLabels];
    self.dayLabel2.font = [UIFont fontWithName:@"steelfish" size:kFontSizeForDetailViewTitleLabels];
    self.dayLabel3.font = [UIFont fontWithName:@"steelfish" size:kFontSizeForDetailViewTitleLabels];
    self.dayLabel4.font = [UIFont fontWithName:@"steelfish" size:kFontSizeForDetailViewTitleLabels];
    self.dayLabel5.font = [UIFont fontWithName:@"steelfish" size:kFontSizeForDetailViewTitleLabels];
    
    self.dayTemp1.font = [UIFont fontWithName:@"steelfish" size:kFontSizeForDetailViewTempLabel];
    self.dayTemp2.font = [UIFont fontWithName:@"steelfish" size:kFontSizeForDetailViewTempLabel];
    self.dayTemp3.font = [UIFont fontWithName:@"steelfish" size:kFontSizeForDetailViewTempLabel];
    self.dayTemp4.font = [UIFont fontWithName:@"steelfish" size:kFontSizeForDetailViewTempLabel];
    self.dayTemp5.font = [UIFont fontWithName:@"steelfish" size:kFontSizeForDetailViewTempLabel];
    
    self.madeWithLoveLabel.font = [UIFont fontWithName:@"steelfish" size:20];
    self.designedByLabel.font = [UIFont fontWithName:@"steelfish" size:20];
    
}

@end
