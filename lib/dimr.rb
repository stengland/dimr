require "dimr/version"
require 'forwardable'
require "dim"

module Dimr
  extend Forwardable

  private

  def run(runable_klass, dependencies, method = :run!)
    Factory.new(runable_klass, dependencies, method)
  end
  alias :command :run
  alias :query :run

  def factory(runable_klass, dependencies)
    Factory.new(runable_klass, dependencies)
  end

  def container
    @container ||= Dim::Container.new
  end

  def_delegators :container, :register_env, :register, :method_missing

  class Factory
    attr_reader :runable_klass, :dependencies, :run_method

    def initialize(runable_klass, dependencies, run_method = nil)
      @runable_klass, @dependencies, @run_method =
        runable_klass, dependencies, run_method
    end

    def call(*args)
      runable = runable_klass.new(*args)

      dependencies.each do |key, value|
        runable.send("#{key}=", value)
      end if dependencies

      if run_method
        runable.public_send(run_method)
      else
        runable
      end
    end
  end

end
