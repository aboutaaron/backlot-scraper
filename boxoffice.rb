require "rubygems"
require "mechanize"
# require "pdf-reader"

# Initialize new Mechanize class
a = Mechanize.new

# Set URI and user agent so Google doesn't redirect us
uri = "https://accounts.google.com/ServiceLogin?service=mail&passive=true&rm=false&continue=http://mail.google.com/mail/&scc=1&ltmpl=default&ltmplcache=2"

# Grab page, enter information and submit
p "Submitting information"
x = a.get(uri).forms.first
x["Email"] = "boxoffice.lat@gmail.com"
x["Passwd"] = "welcome to the times"
x.submit

# Google doesn't like the headless browser so it displays us a dummy page, which can be avoided by setting the basic HTML view as default.

# We should now be at the main Email view. How about we print the first email to confirm?
# In the basic view, the first email is usually the 25th indexed link item.
p "Hopping in the first email..."
a.page.links[25].click

# Setting the HTML view as variable for readability.
html_view = a.page.link_with(:text=> "View as HTML").href

# Uncomment below to click PDF instead
# Coming soon...

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