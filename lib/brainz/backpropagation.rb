module Brainz
  module Algorithms
    module Backpropagation
      def update(input)
        @input_act = input << 0 # 0 - bias

        unless input_weights
          self.num_input ||= @input_act.length
          prepare
        end


        num_hidden.times do |h|
          sum = 0.0
          num_input.times { |i| sum += input_weights[i][h] * input_act[i] }
          hidden_act[h] = sigmoid(sum)
        end

        num_output.times do |o|
          sum = 0.0
          num_hidden.times { |h| sum += hidden_act[h] * output_weights[h][o] }
          output_act[o] = sigmoid(sum)
        end

        self
      end

      def fix_weights(targets)
        output_deltas = [0.0] * num_output

        # calculate error for output neurons
        num_output.times do |k|
          error = targets[k] - output_act[k]
          output_deltas[k] = d_sigmoid(output_act[k]) * error
        end


        # calculate error for hidden neurons
        hidden_deltas = [0.0] * num_hidden
        num_hidden.times do |j|
          error = 0.0
          num_output.times do |k|
            error = error + output_deltas[k] * output_weights[j][k]
            hidden_deltas[j] = d_sigmoid(hidden_act[j]) * error
          end
        end

        # update output weights
        num_hidden.times do |j|
          num_output.times do |k|
            change = output_deltas[k] * hidden_act[j]
            output_weights[j][k] += learning_rate * change + momentum * output_change[j][k]
            output_change[j][k] = change
          end
        end

        # update input weights
        num_input.times do |i|
          num_hidden.times do |j|
            change = hidden_deltas[j] * input_act[i]
            input_weights[i][j] += learning_rate * change + momentum * input_change[i][j]
            input_change[i][j] = change
          end
        end

        error = 0.0
        targets.length.times do |k|
          error += 0.5 * (targets[k] - output_act[k]) ** 2
        end

        @cycle_error += error
      end
    end
  end
end