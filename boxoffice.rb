require "rubygems"
require "mechanize"
require "google_chart"
require "roo"

# Initialize new Mechanize class
a = Mechanize.new

# Set URI to redirct so Google doesn't redirect us to a non-functioning page
uri = "https://accounts.google.com/ServiceLogin?service=mail&passive=true&rm=false&continue=http://mail.google.com/mail/&scc=1&ltmpl=default&ltmplcache=2"

# Grab page, enter information and submit
p "Submitting information"
x = a.get(uri).forms.first
x["Email"] = "boxoffice.lat@gmail.com"
x["Passwd"] = "welcome to the times"
x.submit

# We should now be in the inbox. In the basic HTML view, the first email is usually the 25th indexed link item. So, let's find it and click it.
p "Hopping in the first email..."
# a.page.links[25].click
a.page.links[25].click


# Now in the email body
# Setting the HTML view as variable for readability when GET'ing it.
#html_view = a.page.link_with(:text=> "View as HTML").href
excel_file = a.page.link_with(:text=> "Download").href

# Opening up the HTML view of PDF
p "Opening HTML view of box office attachment..."
a.get("http://mail.google.com" + excel_file)

# Save xls
p "Saving .xls file..."
filename = a.page.filename
a.get("http://mail.google.com" + excel_file).save_as filename

# Grab data from PDF

# Grab each "p" element, iterate and print. Start at first movie - 5th indexed item
movies = a.page.search("p")[5..-3]





























#movies.each do |m|
    # only removes first occurance
    # puts m.text.gsub(/=/,'') removes all, but editor doesn't like
    #.gsub! /\s+/, '' <-- remove whitespace
    #n = m.text.split(/[=]/)
    #title = n[1]
    #puts title
    #m.text.split(/[=]/)
    #puts m
#end


# movies.each{ |m| puts m.text}

# Store everything in a variable called movies
# movies = a.page.search("p")[5..-3]

# Split string by =
# s = a.page.search("p")[5].text.split(/[=]/)



#chart = GoogleChart::LineChart.new('500x600', "Line Chart", false)







# Print first Excel row
# This is 'Amazing Spiderman' and it's values
# a.page.search("p")[5].text


# Now we're presented with html table. Time to scrape and save?
#final = a.page.search("html").map(&:text).map(&:strip)
# Grab the date...
#box_office_date = a.page.search("font:nth-child(4) div").text

# Open file and save webpage
#p "Saving everything to box_office.txt"
#File.open("box_office_#{box_office_date}.txt", 'w'){|f| f.write(final)}
# Only works for Mac OS X and Linux
#{}%x{ open . }