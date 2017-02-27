+++
title = "nexusdeploy"
draft = false
tags = [
    "code",
    "ruby",
    "scripts",
    "nexusdeploy"
]
date = "2015-07-13"
+++
# Nexus deploy artifacts script 


Wat doet dit?

  1. haalt laatste versie van package op uit nuget nexus repository
  2. download nuget package & unzipt & haalt DLL file hier uit (kan 4.5 4.0 of 3.5 versie zijn)
  3. kopiëert dit naar doelserver

Integraal deel van "deployen" in verband met modules, wordt bvb gebruikt in [Teamcity]({{< relref "wiki/code/build/teamcity.md" >}}) configuration

```ruby
require 'nokogiri' # gem install nokogiri first! 
require 'net/http'
require 'zip'	# gem install rubyzip first!
require 'optparse'
require 'time'

def deploy_artifact(artifact, server, repo)
	if repo.nil? then
		repo = "http://server:8888/nexus/service/local/repositories/nuget-prereleases/"
	else
		repo = repo.sub("/local/nuget/", "/local/repositories/")
	end
	nexus_url = "#{repo}content/#{artifact}/"
	print "-- Deploy artifact #{artifact} to #{server} from #{repo}<br/>n"

	print "fetching artifacts from nexus... <br/>n<br/>t#{nexus_url}<br/>n"
	response = Net::HTTP.get_response(URI.parse(nexus_url))
	xml = Nokogiri::XML(response.body).xpath("//content-item").map { |entry|
		hash = Hash.new
		hash['url'] = entry.css("resourceURI").text
		hash['buildnr'] = entry.css("text").text
		hash['date'] = Time.parse(entry.css("lastModified").text)

		hash
	}.sort { |one,two| two['date'] <=> one['date'] }.first

	if xml.nil? then
		throw "Geen XML kunnen parsen uit URL, ligt nexus plat?"
	end

	artifactContentUri = xml['url']
	artifactBuildNr = xml['buildnr']
	artifactDate = xml['date']

	print "fetching last artifact (modified date #{artifactDate}) package file from nexus... <br/>n<br/>t#{artifactContentUri}<br/>n"
	artifact_uri = Nokogiri::XML(Net::HTTP.get_response(URI.parse(artifactContentUri)).body).css("resourceURI").text

	print "fetching artifact (buildnr. #{artifactBuildNr}) itself from nexus... <br/>n"
	nupkg_file = "#{artifact}-#{artifactBuildNr}.nupkg"
	open(nupkg_file, "wb") do |file|
	    file.write(Net::HTTP.get_response(URI.parse(artifact_uri)).body)
	end

	def unzip_and_copy(zip_file, pattern, server)
		zippedfile = zip_file.glob(pattern).first
		unless zippedfile.nil?
			fname = zippedfile.name.split('/').last
			print "<br/>tFound file to copy: #{fname}<br/>n"
			toname = "#{server}<br/><br/>#{fname}"
			File.delete(toname) if File.exist?(toname)
			zippedfile.extract(toname)
		end
	end

	print "unzipping nuget package...<br/>n"
	Zip::File.open(nupkg_file) do |zip_file|
		unzip_and_copy zip_file, 'lib/net35/*.dll', server
		unzip_and_copy zip_file, 'lib/net40/*.dll', server
		unzip_and_copy zip_file, 'lib/net45/*.dll', server
	end
	File.delete(nupkg_file)
	print "-- done, extracted to #{server}.<br/>n"
end

# ex. usage: 
# deploy_artifact 'ModASR', "<br/><br/><br/><br/>server<br/><br/>c$<br/><br/>websites<br/><br/>TestDemo3<br/><br/>bin"
options = {}
ARGV << '-h' if ARGV.empty?
OptionParser.new do |opts|
	opts.banner = "Usage: deploy_artifact.rb [options]"
	opts.on('-r', '--repo REPOSITORY_URL', 'nexus repository url (bvb http://server:8888/nexus/service/local/repositories/nuget-prereleases/ - with trailing slash)') { |v| options[:repo] = v }
	opts.on('-m', '--modules NAME', 'module name (comma separated)') { |v| options[:modules] = v }
	opts.on('-s', '--server NAME', 'server target bin directory') { |v| options[:server] = v }
	opts.on('-h', '--help', 'prints this help') { |v|
		puts opts
		exit
	}
end.parse!

options[:modules].split(",").each do |mod|
	deploy_artifact mod, options[:server], options[:repo]
end

```