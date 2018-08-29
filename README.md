<p align="center">
<img src="https://github.com/minio/gluegun/blob/master/lib/img/Gluegun_icon_1024px.png" width="140px">
</p>

# Gluegun
Gluegun glues markdown files to generate a beautiful documentation site.
 

## Pre-Requisite

A minimum version of ruby2.4 is required.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gluegun'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gluegun

Or in your script:

    require `gluegun`
    
    
## Usage

        NAME:
          gluegun - Glues github markdown files to a documentation site.

        USAGE:
          gluegun COMMAND [ARGUMENTS...]

        COMMANDS:
          generate Generate new docs site with an URL or file path.
          
## Example

        gluegun generate https://github.com/gluegun/site.yml
        
## Building Gluegun Gem
Build the gem using the command 

```
gem build gluegun.gemspec
```

Install the gem
```
gem install gluegun
```

Run the gluegun CLI 
```
./gluegun generate ./site.yml
````
