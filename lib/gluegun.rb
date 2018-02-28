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
      dest_path = @site_map['Output']
      puts dest_path
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
      dest_path = @site_map['Output']
      FileUtils.mkdir_p(dest_path) unless File.exist?(dest_path)

      @site_map['Documents'].each do |categories|
         categories.each do |key, value|
          value.each do |key2|
            orig_link = key2["Link"].dup
            link = raw(key2['Link'])
            if !key2["Slug"]
              key2["Slug"] = get_slug(key2)
            end
            begin
              File.open(File.join(dest_path,"/#{key2["Slug"]}.html"), "w+") do |f|
                f.puts(GitHub::Markdown.render_gfm(open(link).read))
              end
            rescue OpenURI::HTTPError
              puts "WARNING:  " + key + " -> " + key2.keys[0] + ": Page not found, the " + 
                   "corresponding link will not be displayed on the sidebar. (" + orig_link + ")"
            end
          end
        end
      end
      puts "copying css & js..."
      copy_with_path('lib/css', dest_path)
      copy_with_path('lib/js', dest_path)
      puts "done"
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
