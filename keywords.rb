require "rubygems"
require "mechanize"
require "open-uri"
require "fileutils"

# Files
IMAGES = "images"
Dir.mkdir(IMAGES) unless File.exists?(IMAGES)
File.open("captions.txt", "w"){ |somefile| somefile.puts "TOP"}



# Structure
base_url = "http://laiac1b5z1-int.latimes.com"

# Initialize Mechanize
a = Mechanize.new

# Login
x = a.get("http://laiac1b5z1-int.latimes.com/").forms.first
p "Submitting login info..."
x["name"] = "jevon.phillips"
x["password"] = "marvel"
x.submit
