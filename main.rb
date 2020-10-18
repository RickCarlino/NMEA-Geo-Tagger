require "nmea_plus"
require "rubyserial"

# === CONFIGURATION ===
# You can change these if you need to, but make sure you
# understand what you're changing.

GPS_PORT = ENV["GPS_PORT"] || "/dev/ttyACM0"
FILE_LOCATION = "geo.csv"
CSV_HEADERS = "lat, lng, alt, description\n"

# === DATA INITIALIZATION ===
decoder = NMEAPlus::Decoder.new
serialport = Serial.new GPS_PORT # Defaults to 9600 baud, 8 data bits, and no parity
state = { lat: nil, lng: nil, alt: nil, ready: false }
File.write(FILE_LOCATION, CSV_HEADERS) unless File.file?(FILE_LOCATION)

Thread.new do
  puts "Waiting for signal. This could take a while."
  loop do
    raw = serialport.gets
    chunk = raw[1..5]
    if chunk == "GPGGA"
      # safer way to do what we did above
      message = decoder.parse(raw)
      state[:alt] = message.altitude
      state[:lat] = message.latitude
      state[:lng] = message.longitude
      puts "Begin." unless state[:ready]
      state[:ready] = true
    end
  end
end

loop do
  if state[:ready]
    val = gets.chomp
    lat = state.fetch(:lat)
    lng = state.fetch(:lng)
    alt = state.fetch(:alt)
    msg = "#{lat}, #{lng}, #{alt}, #{val}\n"
    Thread.new { `espeak #{val.inspect}` }
    puts msg
    open(FILE_LOCATION, "a") { |f| f << msg }
  end
end
