# NMEA Geo Tagger

A simple ruby script that records lat/long when you type a description.

Example: You want to create a map of points of interest (POIs) in a geographic area by manually marking points from within a vehicle.

# Requirements

 * A Linux laptop
 * A recent version of Ruby
 * `espeak` for voice confirmation of POI entry (`apt install espeak`)
 * An NMEA GPS receiver, like [this one](https://www.amazon.com/gp/product/B073P3Y48Q)

# Setup

```
bundle install
```

The default GPS port is `/dev/ttyACM0`.

You may change the `GPS_PORT` ENV var if your GPS receiver uses something different.

# Use

Run:

```
ruby main.rb
```

Once you see the words "Ready.", you may start typing tags / descriptions of the current GPS coordinate.

Data is stored in CSV format in `geo.csv`.

Data can be easily imported into Google Earth Pro.
