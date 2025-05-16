# Weather
## Overview

This iOS app uses **Core Location** to get the user's current location and fetches a 5-day weather forecast in Celsius using **Alamofire** and the **OpenWeatherMap API**. It displays the forecast in a `UITableView` and allows searching for cities within Egypt. The app handles location permissions, displays weather icons, and saves the last fetched forecast locally in **UserDefaults** as JSON.

## Features

- Request and handle location permissions gracefully.
- Fetch 5-day weather forecast in Celsius for the user's location or searched city.
- Search for cities within Egypt and handle the case when the city is not found.
- Display the forecast in a `UITableView` with temperature, description, and weather icon.
- Show weather icons using URLs in the format: `img/wn/\(iconName)@2x.png`.
- Save the last fetched weather data as JSON in **UserDefaults** for offline access or quick reload.

## How It Works

1. **Location Access**  
   The app requests "When In Use" location permission from the user using Core Location. If permission is denied or restricted, it handles the case gracefully and informs the user.

2. **Fetching Weather Data**  
   Using Alamofire, the app sends HTTP requests to the OpenWeatherMap API, including parameters such as latitude, longitude, units (metric), and API key.

3. **Displaying Forecast**  
   The response JSON is decoded into models and displayed in a table view. Each row shows date, temperature, weather description, and an icon fetched from OpenWeatherMap's icon URL.

4. **City Search**  
   Users can search for cities in Egypt by name. The app queries the API for the specified city and shows an alert if the city is not found.

5. **Data Persistence**  
   The fetched weather data is saved as JSON in UserDefaults, so the app can display the last known forecast without needing to fetch again immediately.

## Screenshots
![WhatsApp Image 2025-05-16 at 23 15 06](https://github.com/user-attachments/assets/19022629-fdcd-4567-ae39-dd4c723be38e)


