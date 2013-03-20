class Reading
 attr_reader :readingNumber
 attr_reader :timeStamp
 attr_reader :indoorTemp
 attr_reader :outdoorTemp
 attr_reader :outdoorHumidity
 attr_reader :absolutePressure
 attr_reader :relativePressure

 def initialize(weatherDataLine) #Array
  @readingNumber = Integer(weatherDataLine[COL_ROWNUMBER])
  @timeStamp = weatherDataLine[COL_TIMESTAMP]
  @indoorTemp = Float(weatherDataLine[COL_INDOOR_TEMP].strip)
  @outdoorTemp = Float(weatherDataLine[COL_OUTDOOR_TEMP].strip)
  @outdoorHumidity=Float(weatherDataLine[COL_OUTDOOR_HUMID].strip)
  @absolutePressure=Float(weatherDataLine[COL_ABS_PRESSURE].strip)  
  @relativePressure=Float(weatherDataLine[COL_REL_PRESSURE].strip)
 end
 def to_json()
  hashtable = {:readingNumber=>@readingNumber, 
               :timeStamp=>@timeStamp, 
			   :indoorTemp=>@indoorTemp, 
			   :outdoorTemp=>@outdoorTemp, 
			   :outdoorHumidity=>@outdoorHumidity, 
			   :absolutePressure=>@absolutePressure, 
			   :relativePressure=>@relativePressure }.to_json
  return hashtable
 end 
 def to_TextLines()
  displayLines = [ 
    "<h1>Weather:</h1><br/>",
	"<table border=1>",
    "<tr><td>Time: </td><td>" + readingTimeString + " " + readingDateString+ "</td>",
    "<tr><td>Indoor Temp: </td><td>" + @indoorTemp.to_s + "&deg;C</td>",
    "<tr><td>Outdoor Temp: </td><td>" +  @outdoorTemp.to_s + "&deg;C</td>",
    "<tr><td>Outdoor Humidity: </td><td>" +  @outdoorHumidity.to_s+"% </td>",
	"<tr><td>Absolute Pressure: </td><td>" +  @absolutePressure.to_s+" Hpa </td>",
    "<tr><td>Relative Pressure: </td><td>" +  @relativePressure.to_s+" Hpa </td>" ,
	"</table>"]
  if @outdoorTemp<ALERT_TEMPERATURE then 
   displayLines+=["It's cold out there every day!"]
  end
  displayLines+=["<p>Program updated 20/03/2013</p>"]
  return displayLines
 end
 def readingDateTime()
  return DateTime.parse(@timeStamp)
 end 
  def readingTimeString()
  readingDateTime = readingDateTime()
  return readingDateTime.hour.to_s+":"+readingDateTime.minute.to_s
 end 
 def readingDateString()
  readingDateTime = readingDateTime()
  return readingDateTime.day.to_s+"/"+readingDateTime.month.to_s+"/"+readingDateTime.year.to_s
 end 
end