require "rubygems"
require "mechanize"
require "open-uri"
require "fileutils"

# Files
IMAGES = "keywords-images"
Dir.mkdir(IMAGES) unless File.exists?(IMAGES)
File.open("captions_keywords.txt", "w"){ |somefile| somefile.puts "TOP"} unless File.exists?("caption_keywords.txt")

# Structure
base_url = "http://laiac1b5z1-int.latimes.com"

# Initialize Mechanize
a = Mechanize.new

# Login
x = a.get(base_url).forms.first
p "Submitting login info..."
x["name"] = "jevon.phillips"
x["password"] = "marvel"
x.submit

# open keyword section w/ appropriate parameters
a.get("http://laiac1b5z1-int.latimes.com/keywords?content_partial=global%2Fcontent_list&filter_by=title&filter_status=all&limit=1000&offset=0&search_published=true&sort_asc=asc&sort_by=modified")
p "Getting all keywords page..."

# Iterate through photos
a.page.links[0..302].each do |x|
    # Open Keyword page
    a.get(base_url+x.href)
    # Open photo records
    a.page.search("td:nth-child(3) a").each do |link|
        image_page = base_url + link['href']
        a.get(image_page)
        # Grab Descriptions, remove whitespace, store in variable photo_info and write to photo.txt
        file_name = a.page.link_with(:href => /\-sxga.jpg/).text
        photo_info = a.page.search("#image_description, #image_caption, #image_title").map(&:text).map(&:strip)

        open("captions_keywords.txt", "a") do |f|
            f << photo_info
            f.puts "\n"
            begin
                f.puts "The file name is " + a.page.link_with(:href => /\-sxga.jpg/).text
            rescue StandardError => e
                puts "Error: #{e}"
            end
            f.puts "\n"*2
        end
        # Click largest image
        begin
            a.page.link_with(:href => /\-sxga.jpg/).click
        rescue StandardError => e
            puts "Could not grab photo..."
            puts "Error: #{e}"
        else
            puts "Grabbing photo..."
        ensure
            sleep 1.0 * rand
        end

        # Setting variables for download
        img_url = a.page.search("img")[0].attributes['src'].text

        # Change to Images Directory and download file
        Dir.chdir("keywords-images") do
            begin
                if File.exist?(file_name)
                    puts "#{file_name} already exist. Moving on..."
                    puts
                else
                    puts "saving #{file_name}"
                    p "Here's your full url..."
                    p image_page
                    a.get(base_url+img_url).save
                    puts
                end
            rescue StandardError => e
                puts "Photo doesn't exist"
                puts "Error: #{e}"
            end
        end
    end
end
exec "figlet 'Finished keywords'"
puts
p "Opening up the 'Images' section with all images. This will take a while..."
# URL with maximum photo size
a.get("http://laiac1b5z1-int.latimes.com/images?content_partial=global%2Fcontent_list&filter_by=title&filter_status=all&filter_val=&limit=1000&offset=20&search_published=false&sort_asc=desc&sort_by=modified")

# Boom
p "Iterating through image links..."
a.page.search("td:nth-child(3) a").each do |link|
    image_page = base_url + link['href']
    a.get(image_page)
    # Grab Descriptions, remove whitespace, store in variable photo_info and write to photo.txt
    photo_info = a.page.search("#image_description, #image_caption, #image_title").map(&:text).map(&:strip)
    file_name = a.page.link_with(:href => /\-sxga.jpg/).text
    if File.exist?("keywords-images/#{file_name}")
        puts "Already have the caption"
    else
        puts "writing caption"
        open("extras.txt", "a") do |f|
            f << photo_info
            f.puts "\n"
            f.puts "The file name is #{file_name}"
            f.puts "\n"*2
        end
    end

    # Click largest image
    a.page.link_with(:href => /\-sxga.jpg/).click

    # Setting variables for download
    img_url = a.page.search("img")[0].attributes['src'].text

    # Change to Images Directory and download file
    Dir.chdir("keywords-images") do
        if File.exist?(file_name)
            puts "File #{file_name} already exist"
        else
            puts "#{file_name} doesn't exist. Saving now..."
            a.get(base_url+img_url).save
        end
    end
end
exec "figlet 'Finished scraping. Grab a beer!'"