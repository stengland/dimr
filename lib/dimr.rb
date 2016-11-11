require "dimr/version"
require 'forwardable'
require "dim"

module Dimr
  extend Forwardable

  private

  def run(runable_klass, dependencies, method = :run!)
    factory(runable_klass, dependencies, method)
  end
  alias :command :run
  alias :query :run

  def factory(runable_klass, dependencies, method = nil)
    Runner.new(runable_klass, dependencies, method)
  end

  def container
    @container ||= Dim::Container.new
  end

  def_delegators :container, :register_env, :register, :method_missing

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
