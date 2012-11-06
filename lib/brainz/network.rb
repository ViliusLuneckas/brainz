module Brainz
  class Network
    attr_reader :input, :hidden, :output

    attr_accessor :training_algorithm, :learning_rate, :momentum, :mse

    def initialize(input_size, hidden_sizes, output_size, options = {})
      self.training_algorithm = :backpropagation

      @input = Layer.new(input_size + 1, self)
      @hidden = hidden_sizes.collect { |size| Layer.new(size, self) }
      @output = Layer.new(output_size, self)

      @learning_rate = options[:learning_rate] || 0.5
      @momentum = options[:momentum] || 0.15
      @mse = 0

      join_layers
    end

    def join_layers
      input.link_to(hidden.first)
      hidden.each_with_index { |layer, i| layer.link_to(hidden[i + 1]) if hidden[i + 1] }
      hidden.last.link_to(output)
    end

    def update(inputs)
      inputs.each_with_index do |value, index|
        input.neurons[index].activation = value
      end
      input.update_forward
    end

    def calculate_deltas(targets)
      output.neurons.each_with_index do |neuron, index|
        neuron.calculate_delta targets[index]
      end
      self.mse += output.calculate_mse(targets)

      hidden.last.calculate_deltas
    end

    def fix_weights(targets)
      calculate_deltas(targets)
      output.adjust_weights
    end
  end
end
