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

@implementation WeatherViewController

@synthesize indexOfCurrentTempString;
@synthesize colorsArray = _colorsArray;
@synthesize largeRectangleScrollView = _largeRectangleScrollView;
@synthesize topSmallRectangleViews = _topSmallRectangleViews;
@synthesize bottomSmallRectangleViews = _bottomSmallRectangleViews;
@synthesize open = _open;
@synthesize isChangingIndex = _isChangingIndex;
@synthesize infoButton = _infoButton;
@synthesize detailView = _detailView;
@synthesize currentWeatherItem = _currentWeatherItem;
@synthesize currentTempLabel = _currentTempLabel;
@synthesize drawerView = _drawerView;
@synthesize soundsEnabled = _soundsEnabled;

-(id)init
{
    self = [super init];
    
    self.colorsArray = [NSArray arrayWithObjects:UIColorFromRGB(0xdb502f), UIColorFromRGB(0xd0632b), UIColorFromRGB(0xd4822c), UIColorFromRGB(0xddac46), UIColorFromRGB(0xe0ca67), UIColorFromRGB(0xe2ce9c), UIColorFromRGB(0xd7dbda), UIColorFromRGB(0xb6cad5), UIColorFromRGB(0x59bbc6), UIColorFromRGB(0x01a9cd), UIColorFromRGB(0x018bbc), UIColorFromRGB(0x0078bd), UIColorFromRGB(0x0068b4), nil];
    
    self.topSmallRectangleViews = [NSMutableArray array];
    self.bottomSmallRectangleViews = [NSMutableArray array];    
    return self;
}

-(void)loadView
{
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.soundsEnabled = YES;

    self.isChangingIndex = NO;
    indexOfCurrentTempString = [[WeatherManager sharedWeatherManager] currentWeatherItem].indexForWeatherMap;    
    self.view.backgroundColor = [UIColor blackColor];
    
    //Top Rectangles, above the currentTemperature Rectangle
    CGFloat y =0;
    for (float i = 0; i < indexOfCurrentTempString; i++) {
        UIColor *color = [self.colorsArray     objectAtIndex:i];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, y, 320, kheightOfSmallRectangles)];
        view.backgroundColor = color;
        y+= view.bounds.size.height;
        
        [self.view addSubview:view];
        [self.topSmallRectangleViews addObject:view];
    }
    
    //CurrentTemperature ScrollView Rectangle
    UIColor *color = [self.colorsArray objectAtIndex:indexOfCurrentTempString];
        
    self.largeRectangleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, 320, 220)];
    self.largeRectangleScrollView.pagingEnabled = YES;
    self.largeRectangleScrollView.showsHorizontalScrollIndicator = NO;
    
    self.largeRectangleScrollView.contentSize = CGSizeMake(640, 220);
    self.largeRectangleScrollView.backgroundColor = color;
    y = self.largeRectangleScrollView.frame.size.height +y;

    //Current Temperature Label 
    self.currentTempLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 180, 160)];
    self.currentTempLabel.font = [UIFont fontWithName:@"steelfish" size:140];
    
    NSString *string= [[WeatherManager sharedWeatherManager] currentWeatherItem].weatherCurrentTemp;
    self.currentTempLabel.text =[NSString stringWithFormat:@"%@°", string];
    self.currentTempLabel.backgroundColor = [UIColor clearColor];
    self.currentTempLabel.textColor = [UIColor whiteColor];
    [self.largeRectangleScrollView addSubview:self.currentTempLabel];
    
    //Picture of Weather 
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.currentTempLabel.bounds.size.width, 30 , 120, 120)];
    [imageView setImage:[UIImage imageNamed:@"sun.png"]];
    [self.largeRectangleScrollView addSubview:imageView];
    
    //Gesture Regognizer for more info pane;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizedOnLargeRectangeView:)];
    tapRecognizer.delegate = self;
    [self.largeRectangleScrollView addGestureRecognizer:tapRecognizer];

    self.drawerView = [[DrawerView alloc] initWithFrame:CGRectMake(0, 170, 320, 50)];
    [self.largeRectangleScrollView addSubview:self.drawerView];
    self.drawerView.backgroundColor = color;
    [self updateDrawerView];
    
    
    self.detailView = [[DetailView alloc] initWithFrame:CGRectMake(320, 0, 320, 220)];
    //self.detailView.item = self.currentWeatherItem ;
    self.detailView.backgroundColor = color;
    
    [self updateDetailView];    
    [self.largeRectangleScrollView addSubview:self.detailView];
    
        
    [self.view addSubview:self.largeRectangleScrollView];
    
    //Bottom rectangles below our current Temperature Rectangle 
    for (float i = indexOfCurrentTempString +1; i < 13; i++) {
        UIColor *color = [self.colorsArray     objectAtIndex:i];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, y-kOffsetForAnimationWhenTapped, 320, kheightOfSmallRectangles)];
        view.backgroundColor = color;
        y+= view.frame.size.height;
        [self.view addSubview:view];
        [self.bottomSmallRectangleViews addObject:view];
    } 
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)updateDrawerView
{
     WeatherItem *currentItem = self.currentWeatherItem;    
    self.drawerView.humidityLabel.font = [UIFont fontWithName:@"steelfish" size:kFontSizeForDrawerViewLabels];
    self.drawerView.precipitationLabel.font = [UIFont fontWithName:@"steelfish" size:kFontSizeForDrawerViewLabels];
    self.drawerView.windLabel.font = [UIFont fontWithName:@"steelfish" size:kFontSizeForDrawerViewLabels];
    
    self.drawerView.humidityLabel.text =[NSString stringWithFormat:@"%@ %%", currentItem.weatherHumidity];
    self.drawerView.precipitationLabel.text =[NSString stringWithFormat:@"%@ in", currentItem.weatherPrecipitationAmount];
    self.drawerView.windLabel.text =[NSString stringWithFormat:@"%@ mph", currentItem.weatherWindSpeed];
    
}

-(void)updateDetailView
{    
    WeatherItem *currentItem = self.currentWeatherItem;    
    
    self.detailView.dayLabel1.text = [currentItem.nextDays objectAtIndex:0];
    self.detailView.dayLabel2.text = [currentItem.nextDays objectAtIndex:1];
    self.detailView.dayLabel3.text = [currentItem.nextDays objectAtIndex:2];
    self.detailView.dayLabel4.text = [currentItem.nextDays objectAtIndex:3];
    self.detailView.dayLabel5.text = [currentItem.nextDays objectAtIndex:4];
    
    self.detailView.dayLabel1.font = [UIFont fontWithName:@"steelfish" size:kFontSizeForDetailViewTitleLabels];
    self.detailView.dayLabel2.font = [UIFont fontWithName:@"steelfish" size:kFontSizeForDetailViewTitleLabels];
    self.detailView.dayLabel3.font = [UIFont fontWithName:@"steelfish" size:kFontSizeForDetailViewTitleLabels];
    self.detailView.dayLabel4.font = [UIFont fontWithName:@"steelfish" size:kFontSizeForDetailViewTitleLabels];
    self.detailView.dayLabel5.font = [UIFont fontWithName:@"steelfish" size:kFontSizeForDetailViewTitleLabels];

    self.detailView.dayTemp1.text = [currentItem.weatherForecast objectAtIndex:0];
    self.detailView.dayTemp2.text = [currentItem.weatherForecast objectAtIndex:1];
    self.detailView.dayTemp3.text = [currentItem.weatherForecast objectAtIndex:2];
    self.detailView.dayTemp4.text = [currentItem.weatherForecast objectAtIndex:3];
    self.detailView.dayTemp5.text = [currentItem.weatherForecast objectAtIndex:4];
    
    self.detailView.dayTemp1.font = [UIFont fontWithName:@"steelfish" size:kFontSizeForDetailViewTempLabel];
    self.detailView.dayTemp2.font = [UIFont fontWithName:@"steelfish" size:kFontSizeForDetailViewTempLabel];
    self.detailView.dayTemp3.font = [UIFont fontWithName:@"steelfish" size:kFontSizeForDetailViewTempLabel];
    self.detailView.dayTemp4.font = [UIFont fontWithName:@"steelfish" size:kFontSizeForDetailViewTempLabel];
    self.detailView.dayTemp5.font = [UIFont fontWithName:@"steelfish" size:kFontSizeForDetailViewTempLabel];


    self.detailView.dayImage1.image = [currentItem.weatherForecastConditionsImages objectAtIndex:0];
    
    self.detailView.dayImage2.image = [currentItem.weatherForecastConditionsImages objectAtIndex:1];

    self.detailView.dayImage3.image = [currentItem.weatherForecastConditionsImages objectAtIndex:2];

    self.detailView.dayImage4.image = [currentItem.weatherForecastConditionsImages objectAtIndex:3];
    self.detailView.dayImage5.image = [currentItem.weatherForecastConditionsImages objectAtIndex:4];

    self.detailView.madeWithLoveLabel.font = [UIFont fontWithName:@"steelfish" size:20];
     self.detailView.designedByLabel.font = [UIFont fontWithName:@"steelfish" size:20];
}

-(void)tapRecognizedOnLargeRectangeView:(UITapGestureRecognizer *)recognizer
{
    [self toggleOpenAndClosedState];
}

-(void)setCurrentWeatherItem:(WeatherItem *)currentWeatherItem
{    
    if (_currentWeatherItem !=currentWeatherItem)
    {
       _currentWeatherItem = currentWeatherItem;
    }
        
    self.currentTempLabel.text = [NSString stringWithFormat:@"%@°", currentWeatherItem.weatherCurrentTemp];

    [self updateDetailView];
    [self updateDrawerView];
}

-(void)setIndexOfCurrentTempString:(int)index
{
    if (self.open)
    {
        [self toggleOpenAndClosedState];
    }
    
    if (self.isChangingIndex ==NO)
    {
        return;
    } else {
        
        if (self.soundsEnabled){
        
            [[SoundManager sharedManager] playClankSound];
        } else {
            //Do Nothing 
        }
    //Animattions
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         //Remove top and bottom views to expose the current temperature view 
                        for (int i=0; i<self.bottomSmallRectangleViews.count; i++)
                         {
                             UIView *view = [self.bottomSmallRectangleViews objectAtIndex:i];
                             [view setFrame:CGRectMake(0, +500, 320, kheightOfSmallRectangles)];
                         }
                         
                         for (int i=0; i<self.topSmallRectangleViews.count; i++)
                         {
                             UIView *view = [self.topSmallRectangleViews objectAtIndex:i];
                             [view setFrame:CGRectMake(0, -1000, 320, kheightOfSmallRectangles)];
                         }    
                     } 
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:0.25
                                               delay:0.0
                                             options: UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              //Animate the current temperature view into its new location 
                                              CGFloat y = index * kheightOfSmallRectangles;
                                              [self.largeRectangleScrollView setFrame:CGRectMake(0, y, 320, 220)];
                                              self.largeRectangleScrollView.backgroundColor = [self.colorsArray objectAtIndex:index];
                                              self.detailView.backgroundColor = [self.colorsArray objectAtIndex:index];
                                              self.drawerView.backgroundColor = [self.colorsArray objectAtIndex:index];
                                          } 
                                          completion:^(BOOL finished){
                                             
                                              if (self.soundsEnabled){
                                                  
                                                   [[SoundManager sharedManager] playSwooshSound];
                                              } else {
                                                  //Do Nothing 
                                              }
                                             
                                              
                                              [UIView animateWithDuration:0.4
                                                                    delay:0.0
                                                                  options: UIViewAnimationOptionCurveEaseIn
                                                               animations:^{
                                                                   //Add Top rectangle views above current temperature view 
                                                                   [self.topSmallRectangleViews removeAllObjects];
                                                                   
                                                                   CGFloat y =0;
                                                                   for (float i = 0; i < index; i++) {
                                                                       UIColor *color = [self.colorsArray     objectAtIndex:i];
                                                                
                                                                       UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, y -500, 320, kheightOfSmallRectangles)];
                                                                       view.alpha = 0;
                                                                       view.backgroundColor = color;
                                                                       y+= view.bounds.size.height;
                                                                       
                                                                       [self.view addSubview:view];
                                                                       [self.topSmallRectangleViews addObject:view];
                                                                       
                                                                       [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                                                                           
                                                                    [view setFrame:CGRectMake(0, y-kheightOfSmallRectangles, 320, kheightOfSmallRectangles)];
                                                                           
                                                                           view.alpha = 1;

                                                                       }completion:^(BOOL finished){
                                                                           
                                                                       }]; 
                                                                   }
                                                                   y = self.largeRectangleScrollView.frame.size.height +y;
                                                                   
                                                                   //Add bottom rectangle views below current temperature view 
                                                                   [self.bottomSmallRectangleViews removeAllObjects];

                                                                   for (float i = index +1; i < 13; i++) {
                                                                       UIColor *color = [self.colorsArray     objectAtIndex:i];
                                                                       
                                                                       UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, y+500, 320, kheightOfSmallRectangles)];
                                                                       view.alpha = 0;
                                                                       view.backgroundColor = color;
                                                                       y+= view.frame.size.height;
                                                                       [self.view addSubview:view];
                                                                       [self.bottomSmallRectangleViews addObject:view];
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
                     }];
    }
    self.isChangingIndex = NO;
}

#pragma mark UIGestureRecognizer Delegate Methods 

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isKindOfClass:[UIButton class]]) {      //change it to your condition
        return NO;
    }
    return YES;
}

#pragma mark WeatherManager Delegate Methods 

-(void)didRecieveAndParseNewWeatherItem:(WeatherItem*)item
{
    self.currentWeatherItem = item;
    
    self.isChangingIndex = YES;
    
    self.indexOfCurrentTempString = item.indexForWeatherMap;
}

-(void)toggleOpenAndClosedState
{
    if (self.indexOfCurrentTempString <10)
    {
        if (self.open)
        {
            self.open = NO;
            for (UIView *view in self.bottomSmallRectangleViews)
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
            self.open = YES;
            for (UIView *view in self.bottomSmallRectangleViews)
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
    else if (self.indexOfCurrentTempString >=10)
    {
        if (self.open)
        {
            self.open = NO;
            [UIView animateWithDuration:0.5
                                  delay:0.0
                                options: UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 CGPoint originOfLargeRectangleScrollView = self.largeRectangleScrollView.frame.origin;
                                 [self.largeRectangleScrollView setFrame:CGRectMake(originOfLargeRectangleScrollView.x, originOfLargeRectangleScrollView.y + kOffsetForAnimationWhenTapped, 320, self.largeRectangleScrollView.frame.size.height)];
                             } 
                             completion:^(BOOL finished){
                             }];            
            for (UIView *view in self.topSmallRectangleViews)
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
            self.open = YES;            
            [UIView animateWithDuration:0.5
                                  delay:0.0
                                options: UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 CGPoint originOfLargeRectangleScrollView = self.largeRectangleScrollView.frame.origin;
                                 [self.largeRectangleScrollView setFrame:CGRectMake(originOfLargeRectangleScrollView.x, originOfLargeRectangleScrollView.y - kOffsetForAnimationWhenTapped, 320, self.largeRectangleScrollView.frame.size.height)];
                             } 
                             completion:^(BOOL finished){
                             }];
            for (UIView *view in self.topSmallRectangleViews)
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
    self.soundsEnabled = YES;
}

-(void)turnSoundsOff
{
    self.soundsEnabled = NO;
}

@end
