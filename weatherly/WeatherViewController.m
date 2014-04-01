//
//  WeatherViewController.m
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


#import "WeatherViewController.h"
#import "DetailView.h"
#import "DrawerView.h"

CGFloat  kAimationDuration = 0.20;
CGFloat  kheightOfLargeRectangleScrollViewClosed = 150;
CGFloat  kOffsetForAnimationWhenTapped = 50;

@interface WeatherViewController ()

//Data
@property (nonatomic, strong) WeatherManager *weatherManager;
@property (nonatomic, strong) WeatherItem *currentWeatherItem;
@property (nonatomic, assign) int indexOfCurrentTempString;
@property (nonatomic, assign) int heightOfRectangles;

//Views
@property (nonatomic, strong) NSMutableArray *topSmallRectangleViews;
@property (nonatomic, strong) NSMutableArray *bottomSmallRectangleViews;

@property (nonatomic, strong) DetailView *detailView;
@property (nonatomic, strong) DrawerView *drawerView;
@property (nonatomic, strong) UIScrollView *largeRectangleScrollView; //Containing detail/drawer views

@property (nonatomic, strong) UIButton *infoButton;

//State
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, assign) BOOL isChangingIndex;
@property (nonatomic, assign) CGFloat currentY;
@property (nonatomic, strong) NSArray *colorsArray;
@property (nonatomic, strong) UIColor *currentColor;

@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0x0068b4);

    // Setup the colors to display
    self.colorsArray = @[UIColorFromRGB(0xdb502f),
                         UIColorFromRGB(0xd0632b),
                         UIColorFromRGB(0xd4822c),
                         UIColorFromRGB(0xddac46),
                         UIColorFromRGB(0xe0ca67),
                         UIColorFromRGB(0xe2ce9c),
                         UIColorFromRGB(0xd7dbda),
                         UIColorFromRGB(0xb6cad5),
                         UIColorFromRGB(0x59bbc6),
                         UIColorFromRGB(0x01a9cd),
                         UIColorFromRGB(0x018bbc),
                         UIColorFromRGB(0x0078bd),
                         UIColorFromRGB(0x0068b4)];
    
    self.heightOfRectangles = ([[UIScreen mainScreen] bounds].size.height - kheightOfLargeRectangleScrollViewClosed) / self.colorsArray.count;

    self.topSmallRectangleViews = [NSMutableArray array];
    self.bottomSmallRectangleViews = [NSMutableArray array];
    
    self.weatherManager = [WeatherManager sharedManager];
    self.weatherManager.delegate = self;
    
    [self setupWeatherViews];
}

- (void)setupWeatherViews {
    self.currentY = 0;
    self.isChangingIndex = NO;
    self.indexOfCurrentTempString = [self.weatherManager currentWeatherItem].indexForWeatherMap;
    
    // Setup the Top Rectangles, above the currentTemperature Rectangle
    [self setupTopRectangles];
    
    // Setup the currentTemperature ScrollView Rectangle, which contains a drawerView and detailView
    [self setupTemperatureScrollView];
    
    // Gesture Regognizer for more info pane
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizedOnLargeRectangeView:)];
    tapRecognizer.delegate = self;
    [self.largeRectangleScrollView addGestureRecognizer:tapRecognizer];
    
    // Setup the drawer view (tap to show)
    self.drawerView = [[DrawerView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 220)];
    [self.largeRectangleScrollView addSubview:self.drawerView];
    self.drawerView.backgroundColor = self.currentColor;
    
    // Setup the detail view (swipe to show)
    self.detailView = [[DetailView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, 220)];
    self.detailView.backgroundColor = self.currentColor;
    [self.largeRectangleScrollView addSubview:self.detailView];

    [self updateDrawerView];
    
    [self.view addSubview:self.largeRectangleScrollView];
    
    // Lastly, setup any Bottom Rectangles below our currentTemperature Rectangle
    [self setupBottomRectangles];
}

// Setup the Top Rectangles, above the currentTemperature Rectangle
- (void)setupTopRectangles {
    for (int i = 0; i < self.indexOfCurrentTempString; i++) {
        UIColor *rectColor = [self.colorsArray objectAtIndex:i];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.currentY, self.view.bounds.size.width, self.heightOfRectangles)];
        view.backgroundColor = rectColor;
        self.currentY += view.bounds.size.height;
        [self.view addSubview:view];
        [self.topSmallRectangleViews addObject:view];
    }
}

- (void)setupBottomRectangles {
    for (int i = self.indexOfCurrentTempString +1; i < [self.colorsArray count]; i++) {
        UIColor *rectColor = [self.colorsArray objectAtIndex:i];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.currentY - kOffsetForAnimationWhenTapped, self.view.bounds.size.width, self.heightOfRectangles)];
        view.backgroundColor = rectColor;
        self.currentY += view.frame.size.height;
        [self.view addSubview:view];
        [self.bottomSmallRectangleViews addObject:view];
    }
}

// Setup the CurrentTemperature ScrollView Rectangle
- (void)setupTemperatureScrollView {
    UIColor *color = [self.colorsArray objectAtIndex:self.indexOfCurrentTempString];
    self.largeRectangleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.currentY, self.view.bounds.size.width, 220)];
    self.largeRectangleScrollView.pagingEnabled = YES;
    self.largeRectangleScrollView.showsHorizontalScrollIndicator = NO;
    self.largeRectangleScrollView.contentSize = CGSizeMake(640, 220);
    self.largeRectangleScrollView.backgroundColor = color;
    self.currentY = self.largeRectangleScrollView.frame.size.height + self.currentY;
    
    [self updateDrawerView];
}

-(void)updateDrawerView {
    // Current Temperature Label
    NSString *string= [self.weatherManager currentWeatherItem].weatherCurrentTemp;
    self.drawerView.currentTempLabel.text =[NSString stringWithFormat:@"%@°", string];
    
    // Picture of Weather
    [self.drawerView.currentTempImageView setImage:[self.weatherManager currentWeatherItem].weatherCurrentTempImage];

    self.drawerView.humidityLabel.text = [NSString stringWithFormat:@"%@ %%", self.currentWeatherItem.weatherHumidity];
    self.drawerView.precipitationLabel.text = [NSString stringWithFormat:@"%@ in", self.currentWeatherItem.weatherPrecipitationAmount];
    self.drawerView.windLabel.text = [NSString stringWithFormat:@"%@ mph", self.currentWeatherItem.weatherWindSpeed];
    
    if (self.currentWeatherItem.nextDays.count){
        self.detailView.dayLabel1.text = [self.currentWeatherItem.nextDays objectAtIndex:0];
        self.detailView.dayLabel2.text = [self.currentWeatherItem.nextDays objectAtIndex:1];
        self.detailView.dayLabel3.text = [self.currentWeatherItem.nextDays objectAtIndex:2];
        self.detailView.dayLabel4.text = [self.currentWeatherItem.nextDays objectAtIndex:3];
        self.detailView.dayLabel5.text = [self.currentWeatherItem.nextDays objectAtIndex:4];
    }
    
    if (self.currentWeatherItem.weatherForecast.count){
        self.detailView.dayTemp1.text = [self.currentWeatherItem.weatherForecast objectAtIndex:0];
        self.detailView.dayTemp2.text = [self.currentWeatherItem.weatherForecast objectAtIndex:1];
        self.detailView.dayTemp3.text = [self.currentWeatherItem.weatherForecast objectAtIndex:2];
        self.detailView.dayTemp4.text = [self.currentWeatherItem.weatherForecast objectAtIndex:3];
        self.detailView.dayTemp5.text = [self.currentWeatherItem.weatherForecast objectAtIndex:4];
    }
    
    if (self.currentWeatherItem.weatherForecastConditionsImages.count){
        self.detailView.dayImage1.image = [self.currentWeatherItem.weatherForecastConditionsImages objectAtIndex:0];
        self.detailView.dayImage2.image = [self.currentWeatherItem.weatherForecastConditionsImages objectAtIndex:1];
        self.detailView.dayImage3.image = [self.currentWeatherItem.weatherForecastConditionsImages objectAtIndex:2];
        self.detailView.dayImage4.image = [self.currentWeatherItem.weatherForecastConditionsImages objectAtIndex:3];
        self.detailView.dayImage5.image = [self.currentWeatherItem.weatherForecastConditionsImages objectAtIndex:4];
    }
}

-(void)tapRecognizedOnLargeRectangeView:(UITapGestureRecognizer *)recognizer {
    [self toggleOpenAndClosedState];
}

-(void)setIndexOfCurrentTempString:(int)index {
    if (self.isChangingIndex == NO) return;
    if (self.isOpen) [self toggleOpenAndClosedState];
    
    // Animations
    [UIView animateWithDuration:kAimationDuration
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         // Remove top and bottom views to expose the current temperature view
                         [self removeTopAndBottomViews];
                     }
                     completion:^(BOOL finished){
                         // Animates the top and bottom rectangles into view
                         [self animateTopAndBottomViewsForIndex:index];
                     }];
    
    self.isChangingIndex = NO;
}

// Remove top and bottom views to expose the current temperature view
- (void)removeTopAndBottomViews {
    for (int i=0; i < self.bottomSmallRectangleViews.count; i++) {
        UIView *view = [self.bottomSmallRectangleViews objectAtIndex:i];
        [view setFrame:CGRectMake(0, +500, self.view.bounds.size.width, self.heightOfRectangles)];
    }
    for (int i=0; i < self.topSmallRectangleViews.count; i++) {
        UIView *view = [self.topSmallRectangleViews objectAtIndex:i];
        [view setFrame:CGRectMake(0, -1000, self.view.bounds.size.width, self.heightOfRectangles)];
    }
}

// Animates the top and bottom rectangles into view
- (void)animateTopAndBottomViewsForIndex:(int)index {
    [UIView animateWithDuration:kAimationDuration
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         // Animate the current temperature view into its new location
                         CGFloat y = index * self.heightOfRectangles;
                         [self.largeRectangleScrollView setFrame:CGRectMake(0, y, self.view.bounds.size.width, 220)];
                         self.largeRectangleScrollView.backgroundColor = [self.colorsArray objectAtIndex:index];
                         self.detailView.backgroundColor = [self.colorsArray objectAtIndex:index];
                         self.drawerView.backgroundColor = [self.colorsArray objectAtIndex:index];
                     }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:kAimationDuration
                                               delay:0.0
                                             options: UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              //Add Top rectangle views above current temperature view
                                              [self.topSmallRectangleViews removeAllObjects];
                                              
                                              CGFloat y =0;
                                              for (float i = 0; i < index; i++) {
                                                  UIColor *color = [self.colorsArray     objectAtIndex:i];
                                                  
                                                  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, y -500, self.view.bounds.size.width, self.heightOfRectangles)];
                                                  view.alpha = 0;
                                                  view.backgroundColor = color;
                                                  y+= view.bounds.size.height;
                                                  
                                                  [self.view addSubview:view];
                                                  [self.topSmallRectangleViews addObject:view];
                                                  
                                                  [UIView animateWithDuration:kAimationDuration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                                      
                                                      [view setFrame:CGRectMake(0, y-self.heightOfRectangles, self.view.bounds.size.width, self.heightOfRectangles)];
                                                      
                                                      view.alpha = 1;
                                                      
                                                  }completion:^(BOOL finished){
                                                      
                                                  }];
                                              }
                                              y = self.largeRectangleScrollView.frame.size.height +y;
                                              
                                              //Add bottom rectangle views below current temperature view
                                              [self.bottomSmallRectangleViews removeAllObjects];
                                              
                                              for (float i = index +1; i < [self.colorsArray count]; i++) {
                                                  UIColor *color = [self.colorsArray objectAtIndex:i];
                                                  
                                                  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, y+500, self.view.bounds.size.width, self.heightOfRectangles)];
                                                  view.alpha = 0;
                                                  view.backgroundColor = color;
                                                  y+= view.frame.size.height;
                                                  [self.view addSubview:view];
                                                  [self.bottomSmallRectangleViews addObject:view];
                                                  [UIView animateWithDuration:kAimationDuration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                                      
                                                      [view setFrame:CGRectMake(0, y-kOffsetForAnimationWhenTapped - self.heightOfRectangles, self.view.bounds.size.width, self.heightOfRectangles)];
                                                      
                                                      view.alpha = 1;
                                                      
                                                  }completion:^(BOOL finished){
                                                      
                                                  }];
                                              }
                                          }
                                          completion:^(BOOL finished){
                                          }];
                     }];
}

#pragma mark UIGestureRecognizer Delegate Methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]]) return NO;
    return YES;
}

#pragma mark WeatherManager Delegate Methods

-(void)didRecieveAndParseNewWeatherItem:(WeatherItem*)item {
    self.currentWeatherItem = item;
    self.isChangingIndex = YES;
    self.indexOfCurrentTempString = item.indexForWeatherMap;
    [self updateDrawerView];
}

-(void)toggleOpenAndClosedState {
    if (self.indexOfCurrentTempString < 10) {
        if (self.isOpen) {
            self.isOpen = NO;
            for (UIView *view in self.bottomSmallRectangleViews) {
                [UIView animateWithDuration:kAimationDuration
                                      delay:0.0
                                    options: UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     CGPoint origin = view.frame.origin;
                                     [view setFrame:CGRectMake(origin.x, origin.y - kOffsetForAnimationWhenTapped, self.view.bounds.size.width, self.heightOfRectangles)];
                                 }
                                 completion:nil];
            }
        } else {
            self.isOpen = YES;
            for (UIView *view in self.bottomSmallRectangleViews) {
                [UIView animateWithDuration:kAimationDuration
                                      delay:0.0
                                    options: UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     CGPoint origin = view.frame.origin;
                                     [view setFrame:CGRectMake(origin.x, origin.y + kOffsetForAnimationWhenTapped, self.view.bounds.size.width, self.heightOfRectangles)];
                                 }
                                 completion:nil];
            }
        }
    }
    else if (self.indexOfCurrentTempString >= 10) {
        if (self.isOpen) {
            self.isOpen = NO;
            [UIView animateWithDuration:kAimationDuration
                                  delay:0.0
                                options: UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 CGPoint originOfLargeRectangleScrollView = self.largeRectangleScrollView.frame.origin;
                                 [self.largeRectangleScrollView setFrame:CGRectMake(originOfLargeRectangleScrollView.x, originOfLargeRectangleScrollView.y + kOffsetForAnimationWhenTapped, self.view.bounds.size.width, self.largeRectangleScrollView.frame.size.height)];
                             }
                             completion:nil];
            for (UIView *view in self.topSmallRectangleViews) {
                [UIView animateWithDuration:kAimationDuration
                                      delay:0.0
                                    options: UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     CGPoint origin = view.frame.origin;
                                     [view setFrame:CGRectMake(origin.x, origin.y + kOffsetForAnimationWhenTapped, self.view.bounds.size.width, self.heightOfRectangles)];
                                 }
                                 completion:nil];
            }
        } else {
            self.isOpen = YES;
            [UIView animateWithDuration:kAimationDuration
                                  delay:0.0
                                options: UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 CGPoint originOfLargeRectangleScrollView = self.largeRectangleScrollView.frame.origin;
                                 [self.largeRectangleScrollView setFrame:CGRectMake(originOfLargeRectangleScrollView.x, originOfLargeRectangleScrollView.y - kOffsetForAnimationWhenTapped, self.view.bounds.size.width, self.largeRectangleScrollView.frame.size.height)];
                             }
                             completion:nil];
            for (UIView *view in self.topSmallRectangleViews) {
                [UIView animateWithDuration:kAimationDuration
                                      delay:0.0
                                    options: UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     CGPoint origin = view.frame.origin;
                                     [view setFrame:CGRectMake(origin.x, origin.y - kOffsetForAnimationWhenTapped, self.view.bounds.size.width, self.heightOfRectangles)];
                                 }
                                 completion:nil];
            }
        }
    }
}

@end
