Weatherli is a fully functional weather app that uses the free.worldweatheronline.com api to show you the weather with a minimalist design. It also uses the Climacons from Adam Whitcroft. 

![Smaller icon](http://dribbble.s3.amazonaws.com/users/14268/screenshots/553778/attachments/41129/weather-explained.jpg "Title here")

I originally saw this design on dribble, a user names Eddie Lobanovskiy created some shots of this [really creative idea for a simple weather app.] (http://dribbble.com/lobanovskiy/projects/60255-Brisk-Weather-App) Almost the same day I saw it I started developing it and in 2 days I had a pretty good working version down. 

I contacted him about working together to release it, and it turns out he found someone else to work with. 4 months later, it is no where to be found, and the app I wrote has been collecting virtual dust in a dropbox folder, so today, I am open sourcing this project for anyone to pick it up and learn from. PLEASE don't submit it to the Appstore…if you do you are a heartless soul who will be ostracized from the open source community for ages… ;)

One more thing, the app can be written better. I wrote this a few months ago, with very, very little time and my development skills have really refined in that time. 

The app basically contains 2 NSMutableArrays of rectangle UIViews, one array for all the rectangles above the current index, and one for all the rectangles slow the index. When the current index is set, a slew of animation blocks animate the 2 arrays of rectangles into place. As soon as the new index is set, both sets of rectangles fly off the screen. Then we either add/remove the current number if rectangles above/below the new current index, and they fly back in. 

![Smaller icon](http://dribbble.s3.amazonaws.com/users/14268/screenshots/553778/weather.jpg
 "Title here")

**Here is how the app works**

- This app uses encodeWithCoder and decodeWithCoder to save the weather data. It really isn't that important to save the data locally because the user will only care about the weather now, not what the weather was 5 days ago. 
- The app has a locationGetter class that fetches the location and informs its delegate (the weatherManager class) when it receives a new location update. The weatherManager class then constructs the correct url with the new location and fetches weather data using the weather api. 
- It fetches and parses the weather data then gives it to the WeatherViewController, where it sets the current index of the weather item.
- There are 12 different rectangles the weather can fit in, each one corresponding to an interval of weather temperatures. Depending on which interval the current temperature is, the view controller sets the weather to the correct index and creates the rectangles above/under the current index. 
- In the viewDidLoad method, we set the right number of rectangles above and below 
- When we set the index of the new weather item, an animation is started to show it

Check out the app and let me know if you have any questions.  Copyright 2012- Ahmed Eid. This app is distributed under the terms of the GNU General Public License. 

Cheers! 
