require 'spec_helper'

describe Puppet::Type.type(:pim).provider(:quagga) do
  describe 'instances' do
    it 'should have an instance method' do
      expect(described_class).to respond_to :instances
    end
  end

  describe 'prefetch' do
    it 'should have a prefetch method' do
      expect(described_class).to respond_to :prefetch
    end
  end

  context 'running-config' do
    before :each do
      described_class.expects(:vtysh).with(
        '-c', 'show running-config'
      ).returns '!
ip multicast-routing'
    end

    it 'should return a resource' do
      expect(described_class.instances.size).to eq(1)
    end

    it 'should return the resource with pim multicast-routing enabled' do
      expect(described_class.instances[0].instance_variable_get('@property_hash')).to eq({
        :name => :quagga,
        :multicast_routing => :true
      })
    end
  end

  context 'running-config without pim multicast-routing' do
    before :each do
      described_class.expects(:vtysh).with(
          '-c', 'show running-config'
      ).returns ''
    end

    it 'should return a resource' do
      expect(described_class.instances.size).to eq(1)
    end

    it 'should return the resource with pim multicast-routing disabled' do
      expect(described_class.instances[0].instance_variable_get('@property_hash')).to eq({
        :name => :quagga,
        :multicast_routing => :false
      })
    end
  end
end
