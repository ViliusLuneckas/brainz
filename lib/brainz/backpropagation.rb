module Brainz
  module Algorithms
    module Backpropagation
      def update(input)
        initialize_network unless @network
        @network.update(input)
        self
      end

      def fix_weights(targets)
        @network.fix_weights(targets)
      end

      def initialize_network
        @network ||= ::Brainz::Network.new(
            num_input, num_hidden, num_output, momentum: momentum, learning_rate: learning_rate
        )
      end
    end
  end
end