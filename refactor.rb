require "rubygems"
require "mechanize"

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
p "Opening up the 'Images' page..."
a.page.links[1].click

# Click on first link
a.page.link_with(:text => "Sarah Roemer plays catch with her dogs on the set of \"The Event\"").click

# Possiblility for iteration:
# a.page.links_with(:class => 'td:nth-child(3) a').each do |e| ....

# next page CSS "#paging_content a"

# Grab Descriptions, remove whitespace, store in variable photo_info and write to photo.txt
photo_info = a.page.search("#image_description , #image_caption, #image_title").map(&:text).map(&:strip)
p "Saving photo content to file..."
File.open("photos.txt", 'w'){|file| file.write(photo_info)}



# Open single photo page and save photo
a.page.links[8].click

