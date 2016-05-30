#!/usr/bin/env ruby
# Ghost 0.1b
# Andy James / Kana.dev
# #

require 'interface/strings'

module Util

  class Tree

    def initialize(path)
      @path = path
    end

    def path
      @path
    end

    def list
      begin
        d = Dir.new(@path)
        d.each do |x|
          puts(x)
        end
      rescue SystemCallError
        puts INVALID_DIRECTORY
      end
    end

  end

end