require 'squeeze'
require 'squeeze/version'
require 'optparse'

module Squeeze
  class Runner
    attr_accessor :count, :template

    def initialize(argv)
      @count = 1
      cmd = option_parser.parse! argv.dup
      return help    if argv.include? '-h' or not template
      return version if argv.include? '-v'
    rescue OptionParser::MissingArgument, OptionParser::InvalidOption
      return help
    end

    protected

    def version
      puts "Squeeze version #{Squeeze::VERSION}"
    end

    def help
      puts option_parser
    end

    def option_parser
      OptionParser.new do |opts|
        opts.banner = 'Usage: squeeze [-v] [-h] [-n count] -t template -- command'
        opts.separator ''
        opts.on('-v', '--version', 'Print the version and exit.')
        opts.on('-h', '--help', 'Print this help.')
        opts.on('-t TEMPLATE', 'Which container to use as base.') { |t| @template = t }
        opts.on('-n COUNT', 'How many containers to spawn.', Integer) { |n| @count = n }
      end
    end
  end
end
