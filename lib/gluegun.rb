require "gluegun/version"
require 'yaml'
require 'open-uri'
require 'github/markdown'
require 'erb'

module Gluegun
  # Your code goes here...
    class Gluegun

      # Execute the given file using he associate app
      def read_site(file_name) 
         
        yml_data = open(file_name).read
     
        # puts yml_data[:title]
        @site_map = YAML.load(yml_data)
        @site_map.each do |key, value|
          puts "--------------------"
          puts key 
          value.each do |key2, value2|
            puts key2["title"] 
            puts key2["link"]
            content_data = open(key2["link"]).read
            @contents = GitHub::Markdown.render_gfm(content_data)
            myfile = File.new("#{key2["slug"]}.html", "w+") 
            myfile.write(@contents)
            

          end
          puts "--------------------"
        end
      end
      
     # def help
     #   print "
     #   You must pass the link to file which has the site configuration.
     #   Usage: #{__FILE__} target
     #   "
     # end

     # unless ARGV.size > 0
     #   help
     #   exit
     # end

     # l = Gluegun.new  
     # target = ARGV.join ' ' 
     # l.read_site target 
  end
end


    
