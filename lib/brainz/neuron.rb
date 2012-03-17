module Brainz
  class Neuron
    attr_accessor :activation, :delta, :output_change
    attr_reader :dendrites, :axon_synapses, :sum, :layer

    def initialize(layer)
      @layer = layer
      @dendrites = []
      @axon_synapses = []
      self.output_change = 0
      self.activation = 0
      reset
    end

    def learning_rate
      layer.learning_rate
    end

    def momentum
      layer.momentum
    end

    def reset
      @sum = 0
    end

    def add(value)
      @sum += value
    end

    def activate
      @activation = fi(@sum)
    end

    def send_signals
      axon_synapses.each { |s| s.to.add(@activation * s.weight) }

    end

    def calculate_delta(target = nil)
      if target
        # output layer
        @delta = d_sigmoid(activation) * (target - activation)
      else
        # middle layer
        error = axon_synapses.collect { |synapse| synapse.to.delta * synapse.weight }.inject(:+)
        @delta = d_sigmoid(activation) * error
      end
    end

    def adjust_weights
      dendrites.each do |synapse|
        change = delta * synapse.from.activation
        synapse.adjust(learning_rate * change + momentum * synapse.change)
        synapse.change = change
      end
    end

    def fi(x)
      Math.tanh(x)
    end

    def d_sigmoid(y)
      1.0 - y ** 2
    end
  end
end