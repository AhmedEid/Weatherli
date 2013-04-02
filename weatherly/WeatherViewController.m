//
//  WeatherViewController.m
//  weatherly
//
//  Created by Ahmed Eid on 5/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WeatherViewController.h"

CGFloat  kheightOfLargeRectangleScrollViewClosed = 150;
CGFloat  kheightOfSmallRectangles = 27;
CGFloat  kOffsetForAnimationWhenTapped = 50;
CGFloat  kFontSizeForDetailViewTitleLabels = 30;
CGFloat  kFontSizeForDetailViewTempLabel = 35;
CGFloat  kFontSizeForDrawerViewLabels = 30;

@interface WeatherViewController ()
{
    WeatherManager *weatherManager;
    WeatherItem *currentWeatherItem;
    
    int indexOfCurrentTempString;
    CGFloat currentY;
    NSArray *colorsArray;
    UIColor *currentColor;
    
    NSMutableArray *topSmallRectangleViews;
    NSMutableArray *bottomSmallRectangleViews;
    
    BOOL isOpen;
    BOOL soundsEnabled;
    BOOL isChangingIndex;
    
    // Views
    UILabel *currentTempLabel;
    UIScrollView *largeRectangleScrollView;
    DetailView *detailView;
    DrawerView *drawerView;
    
    UIButton *infoButton;
}
@end

@implementation WeatherViewController

-(void)loadView
{
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.view.backgroundColor = [UIColor blackColor];
    
    // Setup the colors to display
    colorsArray = [NSArray arrayWithObjects:UIColorFromRGB(0xdb502f), UIColorFromRGB(0xd0632b), UIColorFromRGB(0xd4822c), UIColorFromRGB(0xddac46), UIColorFromRGB(0xe0ca67), UIColorFromRGB(0xe2ce9c), UIColorFromRGB(0xd7dbda), UIColorFromRGB(0xb6cad5), UIColorFromRGB(0x59bbc6), UIColorFromRGB(0x01a9cd), UIColorFromRGB(0x018bbc), UIColorFromRGB(0x0078bd), UIColorFromRGB(0x0068b4), nil];
    
    // Instantiate the temperature color rectangle arrays
    topSmallRectangleViews = [NSMutableArray array];
    bottomSmallRectangleViews = [NSMutableArray array];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Get a reference to the WeatherManager singleton
    weatherManager = [WeatherManager sharedManager];
    
    // Bool for enabling sounds to play
    soundsEnabled = YES;
    
    // Sets up the views to display with updated data
    [self setupWeatherViews];
}

- (void)setupWeatherViews
{
    currentY = 0;
    isChangingIndex = NO;
    indexOfCurrentTempString = [weatherManager currentWeatherItem].indexForWeatherMap;
    
    // Setup the Top Rectangles, above the currentTemperature Rectangle
    [self setupTopRectangles];
    
    // Setup the CurrentTemperature ScrollView Rectangle
    [self setupTemperatureScrollView];
    
    // Gesture Regognizer for more info pane
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizedOnLargeRectangeView:)];
    tapRecognizer.delegate = self;
    [largeRectangleScrollView addGestureRecognizer:tapRecognizer];
    
    // Setup the drawer view (tap to show)
    drawerView = [[DrawerView alloc] initWithFrame:CGRectMake(0, 170, 320, 50)];
    [largeRectangleScrollView addSubview:drawerView];
    drawerView.backgroundColor = currentColor;
    [self updateDrawerView];
    
    // Setup the detail view (swipe to show)
    detailView = [[DetailView alloc] initWithFrame:CGRectMake(320, 0, 320, 220)];
    detailView.backgroundColor = currentColor;
    [self updateDetailView];
    [largeRectangleScrollView addSubview:detailView];
    
    // Finally, add the large rectangluar scrollview that we just setup to the main view
    [self.view addSubview:largeRectangleScrollView];
    
    // Lastly, setup any Bottom Rectangles below our current Temperature Rectangle
    [self setupBottomRectangles];
}

// Setup the Top Rectangles, above the currentTemperature Rectangle
- (void)setupTopRectangles
{
    for (float i = 0; i < indexOfCurrentTempString; i++) {
        currentColor = [colorsArray objectAtIndex:i];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, currentY, 320, kheightOfSmallRectangles)];
        view.backgroundColor = currentColor;
        currentY += view.bounds.size.height;
        [self.view addSubview:view];
        [topSmallRectangleViews addObject:view];
    }
}

- (void)setupBottomRectangles
{
    for (float i = indexOfCurrentTempString +1; i < [colorsArray count]; i++) {
        currentColor = [colorsArray objectAtIndex:i];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, currentY - kOffsetForAnimationWhenTapped, 320, kheightOfSmallRectangles)];
        view.backgroundColor = currentColor;
        currentY += view.frame.size.height;
        [self.view addSubview:view];
        [bottomSmallRectangleViews addObject:view];
    }
}

// Setup the CurrentTemperature ScrollView Rectangle
- (void)setupTemperatureScrollView
{
    UIColor *color = [colorsArray objectAtIndex:indexOfCurrentTempString];
    largeRectangleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, currentY, 320, 220)];
    largeRectangleScrollView.pagingEnabled = YES;
    largeRectangleScrollView.showsHorizontalScrollIndicator = NO;
    largeRectangleScrollView.contentSize = CGSizeMake(640, 220);
    largeRectangleScrollView.backgroundColor = color;
    currentY = largeRectangleScrollView.frame.size.height + currentY;
    
    // Current Temperature Label
    currentTempLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 180, 160)];
    currentTempLabel.font = [UIFont fontWithName:@"steelfish" size:140];
    NSString *string= [weatherManager currentWeatherItem].weatherCurrentTemp;
    currentTempLabel.text =[NSString stringWithFormat:@"%@°", string];
    currentTempLabel.backgroundColor = [UIColor clearColor];
    currentTempLabel.textColor = [UIColor whiteColor];
    [largeRectangleScrollView addSubview:currentTempLabel];
    
    // Picture of Weather
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(currentTempLabel.bounds.size.width, 30 , 120, 120)];
    [imageView setImage:[UIImage imageNamed:@"sun.png"]];
    [largeRectangleScrollView addSubview:imageView];
}

-(void)updateDrawerView
{
    drawerView.humidityLabel.font = [UIFont fontWithName:@"steelfish" size:kFontSizeForDrawerViewLabels];
    drawerView.precipitationLabel.font = [UIFont fontWithName:@"steelfish" size:kFontSizeForDrawerViewLabels];
    drawerView.windLabel.font = [UIFont fontWithName:@"steelfish" size:kFontSizeForDrawerViewLabels];
    
    drawerView.humidityLabel.text = [NSString stringWithFormat:@"%@ %%", currentWeatherItem.weatherHumidity];
    drawerView.precipitationLabel.text = [NSString stringWithFormat:@"%@ in", currentWeatherItem.weatherPrecipitationAmount];
    drawerView.windLabel.text = [NSString stringWithFormat:@"%@ mph", currentWeatherItem.weatherWindSpeed];
}

-(void)updateDetailView
{
    detailView.dayLabel1.text = [currentWeatherItem.nextDays objectAtIndex:0];
    detailView.dayLabel2.text = [currentWeatherItem.nextDays objectAtIndex:1];
    detailView.dayLabel3.text = [currentWeatherItem.nextDays objectAtIndex:2];
    detailView.dayLabel4.text = [currentWeatherItem.nextDays objectAtIndex:3];
    detailView.dayLabel5.text = [currentWeatherItem.nextDays objectAtIndex:4];
    
    detailView.dayLabel1.font = [UIFont fontWithName:@"steelfish" size:kFontSizeForDetailViewTitleLabels];
    detailView.dayLabel2.font = [UIFont fontWithName:@"steelfish" size:kFontSizeForDetailViewTitleLabels];
    detailView.dayLabel3.font = [UIFont fontWithName:@"steelfish" size:kFontSizeForDetailViewTitleLabels];
    detailView.dayLabel4.font = [UIFont fontWithName:@"steelfish" size:kFontSizeForDetailViewTitleLabels];
    detailView.dayLabel5.font = [UIFont fontWithName:@"steelfish" size:kFontSizeForDetailViewTitleLabels];
    
    detailView.dayTemp1.text = [currentWeatherItem.weatherForecast objectAtIndex:0];
    detailView.dayTemp2.text = [currentWeatherItem.weatherForecast objectAtIndex:1];
    detailView.dayTemp3.text = [currentWeatherItem.weatherForecast objectAtIndex:2];
    detailView.dayTemp4.text = [currentWeatherItem.weatherForecast objectAtIndex:3];
    detailView.dayTemp5.text = [currentWeatherItem.weatherForecast objectAtIndex:4];
    
    detailView.dayTemp1.font = [UIFont fontWithName:@"steelfish" size:kFontSizeForDetailViewTempLabel];
    detailView.dayTemp2.font = [UIFont fontWithName:@"steelfish" size:kFontSizeForDetailViewTempLabel];
    detailView.dayTemp3.font = [UIFont fontWithName:@"steelfish" size:kFontSizeForDetailViewTempLabel];
    detailView.dayTemp4.font = [UIFont fontWithName:@"steelfish" size:kFontSizeForDetailViewTempLabel];
    detailView.dayTemp5.font = [UIFont fontWithName:@"steelfish" size:kFontSizeForDetailViewTempLabel];
    
    detailView.dayImage1.image = [currentWeatherItem.weatherForecastConditionsImages objectAtIndex:0];
    detailView.dayImage2.image = [currentWeatherItem.weatherForecastConditionsImages objectAtIndex:1];
    detailView.dayImage3.image = [currentWeatherItem.weatherForecastConditionsImages objectAtIndex:2];
    detailView.dayImage4.image = [currentWeatherItem.weatherForecastConditionsImages objectAtIndex:3];
    detailView.dayImage5.image = [currentWeatherItem.weatherForecastConditionsImages objectAtIndex:4];
    
    detailView.madeWithLoveLabel.font = [UIFont fontWithName:@"steelfish" size:20];
    detailView.designedByLabel.font = [UIFont fontWithName:@"steelfish" size:20];
}

-(void)tapRecognizedOnLargeRectangeView:(UITapGestureRecognizer *)recognizer
{
    [self toggleOpenAndClosedState];
}

-(void)setCurrentWeatherItem:(WeatherItem *)newCurrentWeatherItem
{
    if (currentWeatherItem != newCurrentWeatherItem)
        currentWeatherItem = newCurrentWeatherItem;
    
    currentTempLabel.text = [NSString stringWithFormat:@"%@°", currentWeatherItem.weatherCurrentTemp];
    
    [self updateDetailView];
    [self updateDrawerView];
}

-(void)setIndexOfCurrentTempString:(int)index
{
    if (isChangingIndex == NO) return;
    if (isOpen) [self toggleOpenAndClosedState];
    if (soundsEnabled) [[SoundManager sharedManager] playClankSound];
    
    // Animations
    [UIView animateWithDuration:0.4
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
    
    isChangingIndex = NO;
}

// Remove top and bottom views to expose the current temperature view
- (void)removeTopAndBottomViews
{
    for (int i=0; i < bottomSmallRectangleViews.count; i++)
    {
        UIView *view = [bottomSmallRectangleViews objectAtIndex:i];
        [view setFrame:CGRectMake(0, +500, 320, kheightOfSmallRectangles)];
    }
    for (int i=0; i < topSmallRectangleViews.count; i++)
    {
        UIView *view = [topSmallRectangleViews objectAtIndex:i];
        [view setFrame:CGRectMake(0, -1000, 320, kheightOfSmallRectangles)];
    }
}

// Animates the top and bottom rectangles into view
- (void)animateTopAndBottomViewsForIndex:(int)index
{
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         // Animate the current temperature view into its new location
                         CGFloat y = index * kheightOfSmallRectangles;
                         [largeRectangleScrollView setFrame:CGRectMake(0, y, 320, 220)];
                         largeRectangleScrollView.backgroundColor = [colorsArray objectAtIndex:index];
                         detailView.backgroundColor = [colorsArray objectAtIndex:index];
                         drawerView.backgroundColor = [colorsArray objectAtIndex:index];
                     }
                     completion:^(BOOL finished){
                         
                         if (soundsEnabled) [[SoundManager sharedManager] playSwooshSound];
                         
                         [UIView animateWithDuration:0.4
                                               delay:0.0
                                             options: UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              //Add Top rectangle views above current temperature view
                                              [topSmallRectangleViews removeAllObjects];
                                              
                                              CGFloat y =0;
                                              for (float i = 0; i < index; i++) {
                                                  UIColor *color = [colorsArray     objectAtIndex:i];
                                                  
                                                  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, y -500, 320, kheightOfSmallRectangles)];
                                                  view.alpha = 0;
                                                  view.backgroundColor = color;
                                                  y+= view.bounds.size.height;
                                                  
                                                  [self.view addSubview:view];
                                                  [topSmallRectangleViews addObject:view];
                                                  
                                                  [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                                      
                                                      [view setFrame:CGRectMake(0, y-kheightOfSmallRectangles, 320, kheightOfSmallRectangles)];
                                                      
                                                      view.alpha = 1;
                                                      
                                                  }completion:^(BOOL finished){
                                                      
                                                  }];
                                              }
                                              y = largeRectangleScrollView.frame.size.height +y;
                                              
                                              //Add bottom rectangle views below current temperature view
                                              [bottomSmallRectangleViews removeAllObjects];
                                              
                                              for (float i = index +1; i < [colorsArray count]; i++) {
                                                  UIColor *color = [colorsArray objectAtIndex:i];
                                                  
                                                  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, y+500, 320, kheightOfSmallRectangles)];
                                                  view.alpha = 0;
                                                  view.backgroundColor = color;
                                                  y+= view.frame.size.height;
                                                  [self.view addSubview:view];
                                                  [bottomSmallRectangleViews addObject:view];
                                                  [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                                      
                                                      [view setFrame:CGRectMake(0, y-kOffsetForAnimationWhenTapped - kheightOfSmallRectangles, 320, kheightOfSmallRectangles)];
                                                      
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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]]) return NO;
    
    return YES;
}

#pragma mark WeatherManager Delegate Methods

-(void)didRecieveAndParseNewWeatherItem:(WeatherItem*)item
{
    currentWeatherItem = item;
    isChangingIndex = YES;
    self.indexOfCurrentTempString = item.indexForWeatherMap;
    [self updateDrawerView];
    [self updateDetailView];
}

-(void)toggleOpenAndClosedState
{
    if (indexOfCurrentTempString < 10)
    {
        if (isOpen)
        {
            isOpen = NO;
            for (UIView *view in bottomSmallRectangleViews)
            {
                [UIView animateWithDuration:0.5
                                      delay:0.0
                                    options: UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     CGPoint origin = view.frame.origin;
                                     [view setFrame:CGRectMake(origin.x, origin.y - kOffsetForAnimationWhenTapped, 320, kheightOfSmallRectangles)];
                                 }
                                 completion:^(BOOL finished){
                                 }];
            }
        } else {
            isOpen = YES;
            for (UIView *view in bottomSmallRectangleViews)
            {
                [UIView animateWithDuration:0.5
                                      delay:0.0
                                    options: UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     CGPoint origin = view.frame.origin;
                                     [view setFrame:CGRectMake(origin.x, origin.y + kOffsetForAnimationWhenTapped, 320, kheightOfSmallRectangles)];
                                 }
                                 completion:^(BOOL finished){
                                 }];
            }
        }
    }
    else if (indexOfCurrentTempString >= 10)
    {
        if (isOpen)
        {
            isOpen = NO;
            [UIView animateWithDuration:0.5
                                  delay:0.0
                                options: UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 CGPoint originOfLargeRectangleScrollView = largeRectangleScrollView.frame.origin;
                                 [largeRectangleScrollView setFrame:CGRectMake(originOfLargeRectangleScrollView.x, originOfLargeRectangleScrollView.y + kOffsetForAnimationWhenTapped, 320, largeRectangleScrollView.frame.size.height)];
                             }
                             completion:^(BOOL finished){
                             }];
            for (UIView *view in topSmallRectangleViews)
            {
                [UIView animateWithDuration:0.5
                                      delay:0.0
                                    options: UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     CGPoint origin = view.frame.origin;
                                     [view setFrame:CGRectMake(origin.x, origin.y + kOffsetForAnimationWhenTapped, 320, kheightOfSmallRectangles)];
                                 }
                                 completion:^(BOOL finished){
                                 }];
            }
        } else {
            isOpen = YES;
            [UIView animateWithDuration:0.5
                                  delay:0.0
                                options: UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 CGPoint originOfLargeRectangleScrollView = largeRectangleScrollView.frame.origin;
                                 [largeRectangleScrollView setFrame:CGRectMake(originOfLargeRectangleScrollView.x, originOfLargeRectangleScrollView.y - kOffsetForAnimationWhenTapped, 320, largeRectangleScrollView.frame.size.height)];
                             }
                             completion:^(BOOL finished){
                             }];
            for (UIView *view in topSmallRectangleViews)
            {
                [UIView animateWithDuration:0.5
                                      delay:0.0
                                    options: UIViewAnimationOptionCurveEaseOut
                                 animations:^{
                                     CGPoint origin = view.frame.origin;
                                     [view setFrame:CGRectMake(origin.x, origin.y - kOffsetForAnimationWhenTapped, 320, kheightOfSmallRectangles)];
                                 }
                                 completion:^(BOOL finished){
                                 }];
            }
        }
    }
}

#pragma mark SettingsViewontroller Delegate Methods

-(void)turnSoundsOn
{
    soundsEnabled = YES;
}

-(void)turnSoundsOff
{
    soundsEnabled = NO;
}

@end
