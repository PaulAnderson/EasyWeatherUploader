*EasyWeather Uploader*
===========

Uploads Weather Station Readings by polling easyweather.dat. Renders a HTML page and JSON, and uploads both using FTP.

Use with any weather station that uses Easy Weather software.<br/>
This is what I use: http://proweatherstation.com/default.html

*To use:*
Connect Weather station to PC 
Run EasyWeather
Run WeatherMonitorAndUploader.rb
The script will run continuously, whenever the data file is modified it will read in the last line and upload it.

*Configuration:*
edit the variables in WeatherMonitorAndUploader.rb

