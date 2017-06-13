require "gluegun/version"
require 'yaml'
require 'open-uri'
require 'github/markdown'
require 'erb'
require 'fileutils'

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
      path = File.join 'www'
      FileUtils.mkdir_p(path) unless File.exist?(path)
      File.open(File.join(path,"index.html"), "w+") do |f|
        f << "<!DOCTYPE html>
                      <html lang=\"en\">
                          <head>
                              <meta charset=\"utf-8\">
                              <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">
                              <meta name=\"viewport\" content=\"width=device-width, shrink-to-fit=no, initial-scale=1\">
                              <meta name=\"description\" content=\"\">
                              <meta name=\"author\" content=\"\">

                              <!-- Bootstrap CDN HTML -->
                              <link href=\"https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css\" rel=\"stylesheet\" integrity=\"sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u\" crossorigin=\"anonymous\">

                              <!-- Jquery -->
                              <script src=\"https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js\"></script>

                          <script>
                          $(function() {
                               $(\".nav > li > a\").on(\"click\",function(e) {
                                 e.preventDefault();
                                 $(\"#content\").load(this.href);
                               });
                            });
                          </script>
                          <body>
                            <!-- Sidebar -->
                            <div class=\"container\">
                            	<div class=\"col-sm-2\">
                                <nav class=\"nav-sidebar\">
                              		<ul class=\"nav tabs\">\n"
        yml_data = open(file_name).read
        @site_map = YAML.load(yml_data)
        @site_map.each do |key, value|
          first_entry = true
          f << key + "\n"
          value.each do |key2, value2|
            if key===@site_map.keys[0] && first_entry
              active_keyword="active"
              first_entry = false
            else
              active_keyword=""
            end
            f << "<li class=\"#{active_keyword}\">"
            f << "<a href="
            f << "#{key2["slug"]}.html" + " "
            f << "data-toggle=\"tab\">"
            f << key2["title"]
            f << "</a></li>\n"
          end
        end
        f << "</ul>\n</nav>\n</div>\n"
        f << "<!-- Tab content -->" + "\n"
        f << "<div class=\"tab-content\">\n"
        @site_map.each do |key, value|
          first_entry = true
          value.each do |key2, value2|
            if key===@site_map.keys[0] && first_entry
              active_keyword=" active"
              first_entry = false
            else
              active_keyword=""
            end
            f << "<div class=\"tab-pane#{active_keyword} text-style\" id=\"content\"></div>\n"
          end
        end
        f << "</div>\n</body>\n</html>\n"
      end
    end

    #   >> Gluegun:Gluegun.gluegun_generate_pages("https://raw.githubusercontent.com/minio/gluegun/master/sample_site_config.yml")
    #   => done
    #
    # Arguments:
    #   file_name: (String)

    def self.gluegun_generate_pages(file_name)
        yml_data = open(file_name).read
        puts yml_data
        @site_map = YAML.load(yml_data)
        path = File.join 'www'
        FileUtils.mkdir_p(path) unless File.exist?(path)
        @site_map.each do |key, value|
          puts key

          value.each do |key2, value2|
            puts key2["title"]
            puts key2["link"]
            content_data = open(key2["link"]).read
            @contents = GitHub::Markdown.render_gfm(content_data)
            File.open(File.join(path,"/#{key2["slug"]}.html"), "w+") do |myfile|
              myfile.puts(@contents)
            end
          end
        end
    end
  end
end
