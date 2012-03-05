module Brainz
  class Brainz
    attr_accessor :cycle_error
    # options
    attr_accessor :learning_rate, :momentum, :max_iterations, :wanted_error
    attr_writer :num_hidden
    attr_accessor :teaching, :input_order, :output_order
    attr_accessor :input_act, :hidden_act, :output_act, :error
    attr_accessor :input_layer, :num_input, :output_layer, :num_output
    attr_accessor :input_weights, :output_weights, :input_change, :output_change

    def self.current
      @@current
    end

    def initialize
    end

    def learning_options(options)
      options.each { |option, value| send("#{option}=", value) }
    end

    def num_hidden
      @nu_hidden || (num_input + num_output) * 2 / 3
    end

    def learning_cycle
      @cycle_error = 1.0

      max_iterations.times do |i|
        old_error = cycle_error
        @cycle_error = 0

        yield(i, old_error)

        break if cycle_error <= wanted_error
      end
    end

    def teach(options = {})
      @@current = self

      learning_options({learning_rate: 0.5, momentum: 0.15, wanted_error: 0.02, max_iterations: 1000}.merge(options))

      learning_cycle do |iteration, error|
        yield(iteration, error)
      end
    end

    def that(*args)
      self.teaching = if args.first.is_a?(Hash)
                        hash = args.first
                        self.input_order = hash.keys unless input_order
                        hash
                      elsif args.any?
                        args
                      end
      self
    end

    def is(*args)
      return false if teaching.nil?

      output = if args.first.is_a?(Hash)
                 hash = args.first
                 if output_order
                   output_order.collect { |key| hash[key] }
                 else
                   self.output_order = hash.keys
                   hash.values
                 end
               else
                 args
               end
      @num_output ||= output.length

      input = unless teaching.nil?
                if teaching.is_a?(Hash)
                  input_order ? input_order.collect { |key| teaching[key] } : teaching.values
                else
                  teaching
                end
              end


      update(input)
      back_propagate(output)
      true
    end

    def explain(*args)
      input = if args.first.is_a?(Hash)
                hash = args.first
                input_order ? input_order.collect { |key| hash[key] } : hash.values
              elsif args.any?
                args
              end
      update(input, [])
      if num_output == 1
        output_order ? output_act.map!(&:round).to_hash(output_order) : output_act.first.round
      else
        output_order ? output_act.to_hash(output_order) : output_act
      end
    end

    def update(input, targets = [])
      @num_input ||= input.length + 1
      @num_output ||= targets.length
      @input_weights ||= Array.new(num_input) { Array.new(num_hidden) { Kernel.rand * 0.4 - 0.2 } }
      @output_weights ||= Array.new(num_hidden) { Array.new(num_output) { Kernel.rand * 4 - 2 } }
      @input_change ||= Array.new(num_input) { Array.new(num_hidden) { 0 } }
      @output_change ||= Array.new(num_hidden) { Array.new(num_output) { 0 } }

      @output_act ||= []
      @hidden_act ||= []


      @input_act = input
      @input_act += [0]

      num_hidden.times do |h|
        sum = 0.0
        num_input.times do |i|
          sum += input_weights[i][h] * input_act[i]
        end
        hidden_act[h] = sigmoid(sum)
      end

      num_output.times do |o|
        sum = 0.0
        num_hidden.times { |h| sum += hidden_act[h] * output_weights[h][o] }
        output_act[o] = sigmoid(sum)
      end

      self
    end

    def back_propagate(targets)
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

    include MathUtils
  end
end


def self.method_missing(meth = nil, *args, &block)
  if meth == :that
    Brainz::Brainz.current.send(meth, *args)
  else
    raise NoMethodError
  end
end