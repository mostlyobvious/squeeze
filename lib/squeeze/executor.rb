require 'squeeze'
require 'squeeze/container'

module Squeeze
  class Executor
    def initialize(tasks, template)
      @tasks    = tasks
      @template = template
    end

    def execute
      container = Container.from_template(@template)
      container.run @tasks.first
    end
  end
end
