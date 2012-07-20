# YUICSSMIN [![Build Status](https://secure.travis-ci.org/matthiassiegel/yuicssmin.png)](http://travis-ci.org/matthiassiegel/yuicssmin)

Ruby wrapper for the Javascript port of YUI's CSS compressor.

The YUICSSMIN gem provides CSS compression using YUI compressor from Yahoo. Unlike other gems it doesn't use the Java applet YUI compressor but instead uses the Javascript port via ExecJS. 

## Installation
Install YUICSSMIN from RubyGems:

    gem install yuicssmin

Or include it in your project's Gemfile:

    gem 'yuicssmin'

## Usage

    require 'yuicssmin'
    
    Yuicssmin.compress(File.read("path/to/styles.css"))         # => minified CSS
    
    # Alternatively use instance method...
    
    compressor = Yuicssmin.new
    compressor.compress(File.read("path/to/styles.css"))        # => minified CSS

Files or strings are acceptable as input.

You can pass in a second argument to control the maximum output line length (default 5000 characters):

    Yuicssmin.compress(File.read("path/to/styles.css"), 200)

Note: in most cases line length will only be approximated.

## Rails asset pipeline
Rails 3.1 integrated [Sprockets](https://github.com/sstephenson/sprockets) to provide asset packaging and minimising out of the box. For CSS compression it relies on the [yui-compressor gem](https://github.com/sstephenson/ruby-yui-compressor) which requires Java. To use YUICSSMIN instead, edit your config/application.rb file:

    config.assets.css_compressor = Yuicssmin.new

## Compatibility
Tested with Ruby 1.9.2, 1.9.3, jruby-19mode, rbx-19mode

## Changelog
See [CHANGES](https://github.com/matthiassiegel/yuicssmin/blob/master/CHANGES.md).

## Credits
YUICSSMIN gem was inspired by Ville Lautanala's [Uglifier](https://github.com/lautis/uglifier) gem, released under MIT license.

## Copyright

### YUICSSMIN gem and documentation
Copyright (c) 2012 Matthias Siegel (matthias.siegel@gmail.com)
See [LICENSE](https://github.com/matthiassiegel/yuicssmin/blob/master/LICENSE.md) for details.

### YUI compressor
See [file](https://github.com/matthiassiegel/yuicssmin/blob/master/lib/yuicssmin/cssmin.js).