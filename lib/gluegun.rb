require "gluegun/version"
require 'yaml'
require 'open-uri'
require 'github/markdown'
require 'erb'

module Gluegun
  class Gluegun

    def self.read_site(file_name)
        yml_data = open(file_name).read
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
      
    def self.help
        print "
        NAME:
          gluegun - Glues github markdown files to a documentation site.

        USAGE:
          gluegun COMMAND [ARGUMENTS...]

        COMMANDS:
          generate Generate new docs site with an URL or file path.

        "

    end
  end
end
