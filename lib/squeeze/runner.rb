require 'squeeze'
require 'squeeze/version'
require 'squeeze/template'
require 'squeeze/executor'
require 'optparse'

module Squeeze
  class Runner
    attr_accessor :count, :template_path, :identity_key

    def initialize(argv)
      @count = 1
      cmd = option_parser.parse! argv.dup
      return help    if argv.include? '-h' or not template_path or not identity_key
      return version if argv.include? '-v'

      tasks    = [cmd] * count
      template = Template.new(template_path, identity_key)
      executor = Executor.new(tasks, template)
      output   = executor.execute

      puts output
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
        opts.on('-t TEMPLATE', 'Which container to use as base.') { |t| @template_path = t }
        opts.on('-i IDENTITY', 'Which key to use to ssh into container.') { |i| @identity_key = i }
        opts.on('-n COUNT', 'How many containers to spawn.', Integer) { |n| @count = n }
      end
    end
  end
end
