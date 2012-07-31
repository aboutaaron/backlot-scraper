require "rubygems"
require "mechanize"
require "open-uri"
require "fileutils"

# Files
IMAGES = "keywords-images"
Dir.mkdir(IMAGES) unless File.exists?(IMAGES)
File.open("captions_keywords.txt", "w"){ |somefile| somefile.puts "TOP"} unless File.exists?("caption_keywords.txt")

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

# open keyword section w/ appropriate parameters
a.get("http://laiac1b5z1-int.latimes.com/keywords?content_partial=global%2Fcontent_list&filter_by=title&filter_status=all&limit=1000&offset=0&search_published=true&sort_asc=asc&sort_by=modified")
p "Getting all keywords page..."

# Iterate through photos
a.page.links[0..302].each do |x|
    # Open Keyword page
    a.get(base_url+x.href)
    # Open photo records
    a.page.search("td:nth-child(3) a").each do |link|
        image_page = base_url + link['href']
        p "Here's your full url..."
        p image_page
        puts
        a.get(image_page)
        # Grab Descriptions, remove whitespace, store in variable photo_info and write to photo.txt
        photo_info = a.page.search("#image_description, #image_caption, #image_title").map(&:text).map(&:strip)

        open("captions_keywords.txt", "a") do |f|
            f << photo_info
            f.puts "\n"
            #f.puts "The file name is " + a.page.link_with(:href => /\-sxga.jpg/).text
            f.puts "\n"*2
        end

        # Click largest image
        begin
            a.page.link_with(:href => /\-sxga.jpg/).click
        rescue
            puts "Could not grab photo..."
        else
            puts "photo downloaded"
        end

        # Setting variables for download
        img_url = a.page.search("img")[0].attributes['src'].text

        # Change to Images Directory and download file
        Dir.chdir("keywords-images") do
            a.get(base_url+img_url).save
            # Sleepy time for the request

        end
    end
end