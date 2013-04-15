# Paul's Easy Weather file monitor and uploader. Monitors easyweather.dat for changes, and renders a HTML page and JSON object, uploading them to an FTP server.
# To use: Set the paths and FTP variables as needed. Run Easy Weather, then run this program. 
# Copyright (C) 2013 Paul Anderson
# 
#  This program is free software; you can redistribute it and/or
#  modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation; either version 2
#  of the License, or (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

require 'net/ftp'
require 'json'
require 'date'

require './reading'

EASYWEATHER_PATH = "C:\\Program Files (x86)\\EasyWeather"
EASYWEATHER_DATA_FILENAME = "easyweather.dat"
DATA_FILENAME = EASYWEATHER_PATH + "\\" + EASYWEATHER_DATA_FILENAME 

OUTPUT_FILE_PATH_HTML = "C:\\weather\\index.html"
OUTPUT_FILE_PATH_JSON = "C:\\weather\\latestReading.json"

COL_ROWNUMBER=0
COL_TIMESTAMP=2
COL_INTERVAL=3
COL_INDOOR_HUMID=4
COL_INDOOR_TEMP=5
COL_OUTDOOR_HUMID=6
COL_OUTDOOR_TEMP=7
COL_OUTDOOR_DEWPOINT=8
COL_OUTDOOR_WINDCHILL=9
COL_ABS_PRESSURE=10
COL_REL_PRESSURE=11

ALERT_TEMPERATURE = 14.0

FTP_URL = ''
FTP_USERNAME=''
FTP_PASSWORD=''
FTP_DIR=""
FTP_PASSIVE = true
FTP_MAX_RETRIES=3

def upload()
 puts "Wrote data to file. Uploading to FTP..."
 retries=FTP_MAX_RETRIES
 while retries>=0
  retries=retries-1
  begin
   ftp=Net::FTP.new
   ftp.passive=FTP_PASSIVE
   ftp.connect(FTP_URL,21)
   puts "FTP Connect: " + ftp.last_response
   ftp.login(FTP_USERNAME,FTP_PASSWORD)
   ftp.chdir(FTP_DIR) unless FTP_DIR==""
   ftp.putbinaryfile(OUTPUT_FILE_PATH_HTML)
   ftp.putbinaryfile(OUTPUT_FILE_PATH_JSON)
   ftp.close
   puts "FTP Upload completed."
   break
   rescue Errno::ETIMEDOUT => e
    puts "FTP Failed. Error:" + e.to_s
   rescue Net::FTPTempError => e
    puts "FTP Failed. Error:" + e.to_s
   end
  end
end 

lastWeatherFileTime=""
 puts "Monitoring Weather file : " + DATA_FILENAME
while true
 begin
  #puts "comparing " + lastWeatherFileTime + " with " + latestWeatherLine[COL_ROWNUMBER]
  if lastWeatherFileTime!=File.mtime(DATA_FILENAME) then
   puts ("File Updated") unless lastWeatherFileTime==""
   lastWeatherFileTime= File.mtime(DATA_FILENAME)   
   #sleep 5 #make sure file write complete
   latestWeatherLine = IO.readlines(DATA_FILENAME)[-1].split(", ")
   currentReading = Reading.new(latestWeatherLine)
   displayLines = currentReading.to_TextLines()
   
	#todo: parse date. collect data and generate graphs on server
	#DateTime.parse("2012-12-01 17:08:42").year
	
	#Write HTML and data to screen.
	File.open OUTPUT_FILE_PATH_HTML,"w" do |f|
	f.write "<html><head><meta http-equiv='refresh' content='30'><meta name='viewport' content='width=device-width, initial-scale=1.0'/> <title>Temperature</title></head><body>"
	 displayLines.each do|n|
	  puts n
	  f.write n+"\n"
	 end
	 f.write "</body></html>"
	end
	
	#Write JSON
	File.open OUTPUT_FILE_PATH_JSON,"w" do |f|
	 f.write currentReading.to_json
	end
	
	#upload to ftp
	upload()
    sleep 1 
  end #if
 rescue Errno::EACCES
  lastWeatherFileTime="" #cause retry of file open
  sleep 1
 rescue IOError
   lastWeatherFileTime="" #cause retry of file open
   sleep 1
 rescue SocketError
   lastWeatherFileTime="" #cause retry of file open
   sleep 1
  #ignore, try again
 end #rescue
end #while




