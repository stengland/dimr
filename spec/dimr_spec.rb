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

  describe Dimr::Container do
    subject {
      Dimr::Container.new do
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
  end

  describe Dimr::Container::Runner do
    subject {
      described_class.new(Runable, service: Service, config: :test)
    }

    describe '#call' do
      it 'injects the dependencies' do
        expect(subject.call(some: 'args').service).to be Service
      end

      context 'method is provided' do
        subject {
          described_class.new(Runable, {service: Service}, :run!)
        }
        it 'runs the command and returns the result' do
          expect(subject.call(some: 'args')).to eq :success
        end
      end
    end
  end

end
