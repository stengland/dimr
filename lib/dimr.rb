require "dimr/version"
require 'forwardable'
require "dim"

module Dimr
  extend Forwardable

  private

  def runner(runable_klass, dependencies, method = :run!)
    Runner.new( factory(runable_klass, dependencies) , method)
  end
  alias :command :runner
  alias :query :runner

  def factory(runable_klass, dependencies)
    Factory.new(runable_klass, dependencies)
  end

  def container
    @container ||= Dim::Container.new
  end

  def_delegators :container, :register_env, :register, :method_missing

  class Factory
    def initialize(klass, dependencies)
      @klass, @dependencies = klass, dependencies
    end

    def call(*args)
      instance = @klass.new(*args)

      @dependencies.each do |key, value|
        instance.send("#{key}=", value)
      end if @dependencies

      instance
    end
  end

  class Runner
    def initialize(factory, run_method)
      @run_method, @factory = run_method, factory
    end

    def call(*args)
      runable = @factory.call(*args)
      runable.public_send(@run_method)
    end
  end

end
