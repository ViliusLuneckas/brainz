module Brainz
  class Layer
    attr_reader :neurons, :next_layer, :prev_layer, :network
    attr_accessor :mse

    def initialize(size, network)
      @network = network
      @neurons = Array.new(size) { Neuron.new(self) }
      @mse = 0
    end

    def momentum
      network.momentum
    end

    def learning_rate
      network.learning_rate
    end

    def link_to(layer)
      @next_layer = layer
      neurons.each do |my_neuron|
        layer.neurons.each do |next_neuron|
          ::Brainz::Synapse.link(my_neuron, next_neuron)
        end
      end

      layer.back_link(self)
    end

    def back_link(layer)
      @prev_layer = layer
    end

    def update_forward
      if next_layer
        next_layer.reset
        neurons.each(&:send_signals)
        next_layer.activate
        next_layer.update_forward
      end
    end

    def activate
      neurons.each(&:activate)
    end

    def calculate_deltas
      if prev_layer
        neurons.each(&:calculate_delta)
        prev_layer.calculate_deltas
      end
    end

    def reset
      neurons.each(&:reset)
    end

    def update(*values)
      values.each_with_index do |value, index|
        neurons[index].output = value
      end
    end

    def adjust_weights
      neurons.each(&:adjust_weights)
      prev_layer.adjust_weights if prev_layer
    end

    def calculate_mse(targets)
      mse = 0
      neurons.each_with_index do |neuron, index|
        mse += 0.5 * (targets[index] - neuron.activation) ** 2
      end
      mse
    end
  end
end