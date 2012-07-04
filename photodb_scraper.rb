require "rubygems"
require "mechanize"

agent = Mechanize.new

page = agent.get("http://laiac1b5z1-int.latimes.com/")

form = page.forms[0]

form["name"] = "jevon.phillips"
form["password"] = "marvel"
form.submit