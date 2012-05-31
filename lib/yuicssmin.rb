# coding: utf-8

require "execjs"
require "multi_json"
require "yuicssmin/version"

class Yuicssmin
  
  #
  # Source: https://github.com/yui/yuicompressor/blob/master/ports/js/cssmin.js
  #
  Yui = File.expand_path('../yuicssmin/cssmin.js', __FILE__)
  
  
  #
  # Read Javascript port of YUI CSS compressor
  #
  def initialize
    @context = ExecJS.compile(File.open(Yui, 'r:UTF-8').read)
  end
  
  
  #
  # Compress CSS with YUI
  #
  # @param [String, #read] String or IO-like object that supports #read
  # @param [Integer] Maximum line length
  # @return [String] Compressed CSS
  def self.compress(source, length = 10000)
    self.new.compress(source, length)
  end
  
  
  #
  # Compress CSS with YUI
  #
  # @param [String, #read] String or IO-like object that supports #read
  # @param [Integer] Maximum line length
  # @return [String] Compressed CSS
  def compress(source = '', length = 10000)
    source = source.respond_to?(:read) ? source.read : source.to_s
    
    js = []
    js << "var result = '';"
    js << "var length = #{length};"
    js << "var source = #{MultiJson.dump(source)};"
    js << "result = YAHOO.compressor.cssmin(source, length);"    
    js << "return result;"
    
    @context.exec js.join("\n")
  end
end
