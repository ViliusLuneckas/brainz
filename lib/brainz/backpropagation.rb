module Brainz
  module Algorithms
    module Backpropagation
      def update(input)
        @network ||= ::Brainz::Network.new(
            @num_input, [num_hidden, @num_output * 2], @num_output, momentum: momentum, learning_rate: learning_rate
        )
        @network.update(input)
        self
      end

      def fix_weights(targets)
        @network.fix_weights(targets)
      end
    end
  end
end