require "dimr/version"
require "dim"

module Dimr
  class Container < Dim::Container
    def initialize(parent=nil, &block)
      super(parent)
      self.instance_eval(&block)
    end

    def run(runable_klass, dependencies, method = :run!)
      factory(runable_klass, dependencies, method)
    end
    alias :command :run
    alias :query :run

    def factory(runable_klass, dependencies, method = nil)
      Runner.new(runable_klass, dependencies, method)
    end

    class Runner
      attr_reader :runable_klass, :dependencies, :method

      def initialize(runable_klass, dependencies, method = nil)
        @runable_klass, @dependencies, @method =
          runable_klass, dependencies, method
      end

      def call(*args)
        runable = runable_klass.new(*args)

        dependencies.each do |key, value|
          runable.send("#{key}=", value)
        end if dependencies

        if method
          runable.public_send(method)
        else
          runable
        end
      end
    end
  end
end
