require "dimr/version"
require "dim"

module Dimr
  class Container < Dim::Container
    def initialize(&block)
      super
      self.instance_eval(&block)
    end

    def run(runable_klass, dependencies)
      Runner.new(runable_klass, dependencies)
    end
    alias :command :run
    alias :query :run

    Runner = Struct.new(:runable_klass, :dependencies) do
      def call(*args)
        runable = runable_klass.new(*args)

        dependencies.each do |key, value|
          runable.send("#{key}=", value)
        end if dependencies

        runable.run!
      end
    end
  end
end
