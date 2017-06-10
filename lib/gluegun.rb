require "gluegun/version"
require 'yaml'
require 'open-uri'
require 'github/markdown'
require 'erb'

module Gluegun
  class Gluegun

    # Generate index.html
    #
    # Example:
    #   >> Gluegun:Gluegun.gluegun_generate_index("https://raw.githubusercontent.com/minio/gluegun/master/sample_site_config.yml")
    #   => done
    #
    # Arguments:
    #   file_name: (String)
    def self.gluegun_generate_index(file_name)
      open('../www/index.html', 'w') { |f|
        f << "<!DOCTYPE html>
                      <html lang=\"en\">
                          <head>
                              <meta charset=\"utf-8\">
                              <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">
                              <meta name=\"viewport\" content=\"width=device-width, shrink-to-fit=no, initial-scale=1\">
                              <meta name=\"description\" content=\"\">
                              <meta name=\"author\" content=\"\">

                              <title>Simple Sidebar - Start Bootstrap Template</title>

                              <!-- Bootstrap Core CSS -->
                              <link href=\"css/bootstrap.min.css\" rel=\"stylesheet\">

                              <!-- Custom CSS -->
                              <link href=\"css/simple-sidebar.css\" rel=\"stylesheet\">

                              <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
                              <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
                              <!--[if lt IE 9]>
                                  <script src=\"https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js\"></script>
                                  <script src=\"https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js\"></script>
                              <![endif]-->
                          </head>
                          <body>
                            <div>
                            <!-- Sidebar -->
                            <div id=\"sidebar-wrapper\">
                                <ul class=\"sidebar-nav\">"
          yml_data = open(file_name).read
          @site_map = YAML.load(yml_data)
          @site_map.each do |key, value|
              value.each do |key2, value2|
                f << "<li>"
                f << key
                f << "<a href="
                f << "#{key2["slug"]}.html"
                f << ">"
                f << key2["title"]
                f << "</a>"
                f << "</li>"
              end
          end
          f << "</ul>"
          f << "</div></div></body></html>"
      }
    end


    # Generate page htmls
    #
    # Example:
    #   >> Gluegun:Gluegun.gluegun_generate_pages("https://raw.githubusercontent.com/minio/gluegun/master/sample_site_config.yml")
    #   => done
    #
    # Arguments:
    #   file_name: (String)

    def self.gluegun_generate_pages(file_name)
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
            myfile = File.new("../www/#{key2["slug"]}.html", "w+")
            myfile.write(@contents)
          end
          puts "--------------------"
        end
    end
  end
end
