require File.expand_path("../../../base", __FILE__)

require "omniconfig"

describe Vagrant::Config::ProvisionerStructure do
  include_context "unit"

  let(:instance) { described_class.new }

  it "should raise a TypeError if the value is not a hash" do
    expect { instance.value(7) }.to raise_error(OmniConfig::TypeError)
  end

  it "should return just hash if its invalid" do
    data = { "foo" => "bar" }
    instance.value(data).should == data
  end

  it "should return the provisioner value if the type is registered" do
    provisioner_class = Class.new do
      def self.config_class
        Class.new(OmniConfig::Type::Base) do
          def value(raw)
            { "foo" => "bar" }
          end
        end
      end
    end

    result = instance.value("provisioner_class" => provisioner_class)
    result.should == {
      "provisioner_class" => provisioner_class,
      "foo" => "bar"
    }
  end
end