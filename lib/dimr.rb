require "dimr/version"
require "dim"

module Dimr
  class Container < Dim::Container
    def initialize(&block)
      super
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

    Runner = Struct.new(:runable_klass, :dependencies, :method) do
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
