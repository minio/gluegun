require "gluegun/version"
require 'yaml'
require 'open-uri'
require 'github/markdown'
require 'erb'
require 'fileutils'

module Gluegun

  class Gluegun

    def self.gluegun_generate_index(site_config_file)
      config_file = get_config_file(site_config_file)
      html_file = 'index.html'
      partial_erb_arr =['lib/index.erb', 'lib/_header.erb',
                        'lib/_sidebar.erb', 'lib/_footer.erb']
      @site_map = YAML.load(open(config_file).read)
      dest_path = @site_map['destination']
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
      config_file = get_config_file(site_config_file)
      @site_map = YAML.load(open(config_file).read)
      dest_path = @site_map['destination']
      FileUtils.mkdir_p(dest_path) unless File.exist?(dest_path)
      @site_map['docs'].each do |key, value|
        value.each do |key2, value2|
          link = raw(key2['link'])
          File.open(File.join(dest_path,"/#{key2['slug']}.html"), "w+") do |f|
            f.puts(GitHub::Markdown.render_gfm(open(link).read))
          end
        end
      end
    end

    private

    def self.get_config_file(site_config_file)
      if site_config_file.empty?
        config_file = './sample_site_config.yml'
      else
        config_file = raw(site_config_file)
      end
    end

    def self.raw(link)
      if link =~ /\/github.com\//
        # Link is not raw, convert it
        replacements = [ ["github", "raw.githubusercontent"],
                         ["/blob", ""] ]
        replacements.each do |replacement|
          link.gsub!(replacement[0], replacement[1])
        end
      end
      return link
    end

  end
end
