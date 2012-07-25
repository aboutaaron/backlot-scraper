require "rubygems"
require "mechanize"
require "open-uri"

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
#a.page.links[1].click
a.get("http://laiac1b5z1-int.latimes.com/images?content_partial=global%2Fcontent_list&filter_by=title&filter_status=all&filter_val=&limit=1000&offset=20&search_published=false&sort_asc=desc&sort_by=modified")

p "Iterating through links..."
# A test
a.page.search("td:nth-child(3) a").each do |link|
    image_page = base_url + link['href']
    p "Here's your full url..."
    p image_page
    puts
    a.get(image_page)
    # Grab Descriptions, remove whitespace, store in variable photo_info and write to photo.txt
    photo_info = a.page.search("#image_description , #image_caption, #image_title").map(&:text).map(&:strip)
    p photo_info
    puts
    # Click largest image
    a.page.link_with(:href => /\-sxga.jpg/).click

    # Setting variables for download
    img_url = a.page.search("img")[0].attributes['src'].text

    # Download file
    a.get(base_url+img_url).save
end