require 'spec_helper'

describe Dimr do
  Runable = Struct.new(:args) do
    attr_accessor :service, :config
    def run!
      service.call
    end
  end
  Service = -> {:success}

  it 'has a version number' do
    expect(Dimr::VERSION).not_to be nil
  end

  subject {
    Module.new do
      extend Dimr

      register :my_command do
        run(
          Runable,
          service: Service,
          config: :test
        )
      end

      register :my_factory do
        factory(
          Runable,
          service: Service,
          config: :test
        )
      end
    end
  }

  describe '#run' do
    it 'runs the command on the service' do
      expect(subject.my_command.(some: 'args')).to eq :success
    end
  end

  describe '#factory' do
    it 'returns an instance of the runable' do
      expect(subject.my_factory.(some: 'args')).to be_a Runable
    end
  end

  describe Dimr::Factory do
    subject {
      described_class.new(Runable, service: Service, config: :test)
    }

    describe '#call' do
      it 'builds a runable object instance' do
        expect(subject.call(some: 'args').class).to eq Runable
      end
      it 'injects the dependencies the runable instance' do
        expect(subject.call(some: 'args').service).to be Service
      end

      context 'a run method is provided' do
        subject {
          described_class.new(Runable, {service: Service}, :run!)
        }
        it 'sends the run_method to runable instance and returns the result' do
          expect(subject.call(some: 'args')).to eq :success
        end
      end
    end
  end

end
