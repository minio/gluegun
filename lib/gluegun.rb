require "gluegun/version"
require 'yaml'
require 'open-uri'
require 'github/markdown'
require 'erb'
require 'fileutils'

module Gluegun

  class Gluegun

    def self.gluegun_generate_index(site_config_file)
      dest_path = 'www'
      html_file = 'index.html'
      partial_erb_arr =['lib/index.erb', 'lib/_header.erb',
                        'lib/_sidebar.erb', 'lib/_footer.erb']
      @site_map = YAML.load(open(site_config_file).read)
      FileUtils.mkdir_p(dest_path) unless File.exist?(dest_path)
      File.open(File.join(dest_path, html_file), "w+") do |f|
        partial_erb_arr.each do |partial_erb|
          # Set nil to "-" to activate "<%-" and "-%>" characters
          # for non-printing lines in erb file.
          # This will prevent extraneous newlines and indentations
          # in the generated html file.
          f.puts(ERB.new(File.read(partial_erb), nil, '-').result(binding))
        end
      end
    end

    def self.gluegun_generate_pages(site_config_file)
      dest_path = 'www'
      FileUtils.mkdir_p(dest_path) unless File.exist?(dest_path)
      YAML.load(open(site_config_file).read).each do |key, value|
        value.each do |key2, value2|
          File.open(File.join(dest_path,"/#{key2["slug"]}.html"), "w+") do |f|
            f.puts(GitHub::Markdown.render_gfm(open(key2["link"]).read))
          end
        end
      end
    end
  end
end
