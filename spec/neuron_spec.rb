require_relative '../spec/spec_helper'

describe Brainz::Neuron do
  before do
    brainz = Brainz::Brainz.new
    brainz.stubs(num_input: 2, num_output: 2, learning_rate: 1.66, momentum: 0.123)
    brainz.initialize_network
    @neuron = brainz.network.input.neurons.first
  end

  it "should get learning rate from brainz" do
    @neuron.learning_rate.should == 1.66
  end

  it "should get momentum from brainz" do
    @neuron.momentum.should == 0.123
  end
end
