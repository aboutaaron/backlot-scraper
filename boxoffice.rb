require "rubygems"
require "mechanize"
require "google_chart"
# require "pdf-reader"

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
a.page.links[26].click


# Now in the email body
# Setting the HTML view as variable for readability when GET'ing it.
html_view = a.page.link_with(:text=> "View as HTML").href

# Opening up the HTML view
p "Opening HTML view of box office attachment..."
a.get("http://mail.google.com" + html_view)

# Now we're presented with html table. Time to scrape and save?
final = a.page.search("html").map(&:text).map(&:strip)
# Grab the date...
box_office_date = a.page.search("font:nth-child(4) div").text

# Open file and save webpage
p "Saving everything to box_office.txt"
File.open("box_office_#{box_office_date}.txt", 'w'){|f| f.write(final)}
p "Done!"
# Only works for Mac OS X and Linux
p "Kicking open the directory..."
%x{ open . }