require "rubygems"
require "mechanize"

# Initialize Mechanize
agent = Mechanize.new

# Set URI
page = agent.get("http://laiac1b5z1-int.latimes.com/")
form = page.forms[0]

# Login
form["name"] = "jevon.phillips"
form["password"] = "marvel"
form.submit

# Click Images Link -- second link from top
agent.page.links[1].click