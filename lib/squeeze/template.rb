require 'squeeze'

module Squeeze
  class Template
    attr_accessor :path, :name, :key

    def initialize(template_path, key_path)
      @path = File.expand_path(template_path)
      @name = File.basename(template_path)
      @key  = File.expand_path(key_path)
    end
  end
end
