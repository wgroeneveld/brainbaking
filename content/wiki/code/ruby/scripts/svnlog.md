+++
title = "svnlog"
draft = false
tags = [
    "code",
    "ruby",
    "scripts",
    "svnlog"
]
date = "2015-07-13"
+++
# Svnlog 

```ruby
require 'nokogiri' # gem install nokogiri first! 
require 'csv'
require 'date'

# Ex. XML: <log> ... </log>
# <logentry revision="x">
# => <author>name</author>
# => <date>yyyy-mm-ddThh:mm:ssss</date>
# => <msg>message</msg>
# </logentry>

puts "SVN Release notes creator"
puts "---------"

puts "Revision from? (ex revision '8722' or date {YYYY-MM-DD} or 'HEAD') > "
revFrom = gets.chomp
puts "Revision to? > "
revTo = gets.chomp

puts "Getting log from SVN, hang in there... "

rmFile = File.open('svnlog_redmine.txt', 'w')
btFile = File.open('svnlog_bridgetrak.txt', 'w')
storyFile = File.open('svnlog_stories.txt', 'w')
csv = CSV.open('svnlog.csv', 'wb')

[ '.', 'PFW.Base' ].map { |dir|
	puts " -- processing dir '#{dir}' ..."
	rawxml = `cd #{dir} && svn log --xml --revision #{revFrom}:#{revTo}`

	xml = Nokogiri::XML(rawxml)
	xml.xpath("//logentry").map { |entry|
		hash = Hash.new
		hash['rev'] = entry.attr("revision")
		hash['author'] = entry.css("author").text
		hash['date'] = DateTime.strptime(entry.css("date").text, '%Y-%m-%dT%H:%M:%S')
		hash['msg'] = entry.css("msg").text.strip.tr("<br/>n", "")
		hash['btIssues'] = hash['msg'].scan(/bt#([0-9]+)/i).flatten.uniq
		hash['rmIssues'] = hash['msg'].scan(/rm#([0-9]+)/i).flatten.uniq.map { |rm| "http://server.cloudapp.net/redmine/issues/#{rm}" }
		hash['stories'] = hash['msg'].scan(/story#(<br/>S+)<br/>s/i).flatten.uniq

		hash
	}
}.flatten.sort_by { |hash| hash['date'] }.each do |entry|
	rm = entry['rmIssues'].join(', ')
	csv << [ 'r' + entry['rev'], entry['date'], entry['author'], entry['msg'], rm ]
	entry['btIssues'].each do |issue|
		btFile << issue << "<br/>n"
	end
	entry['rmIssues'].each do |issue|
		rmFile << issue << "<br/>n"
	end
	entry['stories'].each do |issue|
		storyFile << issue << "<br/>n"
	end
end


puts "----"
puts "DONE: see svnlog.csv & svnlog_X.txt files"
```
