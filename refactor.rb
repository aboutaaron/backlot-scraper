require "rubygems"
require "mechanize"

# Initialize Mechanize
a = Mechanize.new

a.get("http://laiac1b5z1-int.latimes.com/").forms.first do |x|
    x.forms.first["name"] = "jevon.phillips"
    x.forms.first["password"] = "marvel"
    x.forms.first.submit

    # Click page
    a.page.links[1].click

end