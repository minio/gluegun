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
      partial_erb_arr =[
              'lib/index.erb',
              'lib/_sidebar.erb',
              'lib/_header.erb',
              'lib/_content.erb',
              'lib/_footer.erb'
              ]
      @site_map = YAML.load(open(config_file).read)
      dest_path = @site_map['Output']
      if !dest_path.nil?
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
      else
        puts "Missing destination directory in site.yml file."
      end
    end

    def self.gluegun_generate_pages(site_config_file)
      config_file = get_config_file(site_config_file)
      @site_map = YAML.load(open(config_file).read)
      dest_path = @site_map['Output']
      if ! dest_path.nil?
        FileUtils.mkdir_p(dest_path) unless File.exist?(dest_path)
        if !@site_map['Documents'].nil?
          @site_map['Documents'].each do |categories|
            categories.each do |key, value|
              if !value
                puts "ERROR:  " + key + ": gluegun cannot not generate docs from this link. " +
                      "Please check links under (" +  key + ") in site.yml file. "
                exit (false)
              end
              value.each do |key2|
                if ! key2["Link"]
                  puts "ERROR:  " + key + " -> " + key2.keys[0] + ": gluegun cannot not generate docs from this link. " +
                      "Please check links under (" +  key2.keys[0] + ") in site.yml file. "
                  exit (false)
                else
                  orig_link = key2["Link"].dup
                  link = raw(key2['Link'])
                end
                if !key2["Slug"]
                  key2["Slug"] = get_slug(key2)
                end
                begin
                  File.open(File.join(dest_path,"/#{key2["Slug"]}.html"), "w+") do |f|
                    f.puts(GitHub::Markdown.render_gfm(open(link).read))
                  end
                rescue OpenURI::HTTPError
                  # Calling an empty puts to create a new line.
                  puts
                  puts "WARNING:  " + key + " -> " + key2.keys[0] + ": gluegun cannot not fetch content from this link. " +
                      "Please check this link (" + orig_link + ") in site.yml file. "
                end
              end
            end
          end
          # Calling an empty puts to create a new line.
          puts
          puts "Generating html file..."
          puts "Copying assets..."
          copy_with_path('lib/css', dest_path)
          copy_with_path('lib/img', dest_path)
          copy_with_path('lib/js', dest_path)
          copy_with_path('lib/vendors', dest_path)
          puts "Done"
        else
          puts "Missing document links in the site.yml file."
        end
      else
        puts "Missing destination directory in site.yml file."
      end
    end

    def self.reveal(link)
      begin
        response = GitHub::Markdown.render_gfm(open(link).read)
        return response
      rescue OpenURI::HTTPError
      end
    end

    private

    def self.get_config_file(site_config_file)
      if site_config_file.empty?
        config_file = './site.yml'
      else
        config_file = raw(site_config_file)
        # TO DO: handle cases where the config file cannot be accessed.
      end
    end

    def self.get_slug(key)
      return key.keys[0].downcase.tr(" ", "-")
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

    def self.copy_with_path(src, dst)
      FileUtils.mkdir_p(File.dirname(dst))
      FileUtils.cp_r(src, dst)
    end

  end
end