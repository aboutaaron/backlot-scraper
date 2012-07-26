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

# Click on Image page
p "Opening up the 'Images' page with all images. This will take a while..."
puts
puts
# URL with maximum photo size
a.get("http://laiac1b5z1-int.latimes.com/images?content_partial=global%2Fcontent_list&filter_by=title&filter_status=all&filter_val=&limit=1000&offset=20&search_published=false&sort_asc=desc&sort_by=modified")

# Boom
p "Iterating through links..."
a.page.search("td:nth-child(3) a").each do |link|
    image_page = base_url + link['href']
    p "Here's your full url..."
    p image_page
    puts
    a.get(image_page)
    # Grab Descriptions, remove whitespace, store in variable photo_info and write to photo.txt
    photo_info = a.page.search("#image_description, #image_caption, #image_title").map(&:text).map(&:strip)

    open("captions.txt", "a") do |f|
        f << photo_info
        f.puts "\n"
        f.puts "#{image_page}"
        f.puts "\n"*2
    end

    # Click largest image
    a.page.link_with(:href => /\-sxga.jpg/).click

    # Setting variables for download
    img_url = a.page.search("img")[0].attributes['src'].text

    # Change to Images Directory and download file
    Dir.chdir("images") do
        a.get(base_url+img_url).save
        # Sleepy time for the request

    end
end