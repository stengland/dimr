require 'spec_helper'

describe Dimr do
  it 'has a version number' do
    expect(Dimr::VERSION).not_to be nil
  end
end

describe Dimr::Container::Runner do
  let(:runable_klass) { Struct.new(:args) do
    attr_accessor :service, :config
    def run!
      service.call
    end
  end }
  let(:service) { double(:service, call: :success) }

  subject {
    described_class.new(runable_klass, service: service, config: :test)
  }

  describe '#call' do
    it 'injects the dependencies' do
      expect(subject.call(some: 'args')).to eq :success
    end

    it 'runs the command and returns the result' do
      expect(subject.call(some: 'args')).to eq :success
    end
  end
end

