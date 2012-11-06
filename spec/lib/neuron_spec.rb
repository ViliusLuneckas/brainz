require 'spec_helper'

describe Brainz::Neuron do
  before do
    @brainz = Brainz::Brainz.new
    @brainz.stubs(num_input: 2, num_output: 2, learning_rate: 1.66, momentum: 0.123)
    @brainz.initialize_network
  end

  subject { @brainz.network.input.neurons.first }

  it "should return learning rate of brainz" do
    subject.learning_rate.should == 1.66
  end

  it "should return momentum of brainz" do
    subject.momentum.should == 0.123
  end
end
