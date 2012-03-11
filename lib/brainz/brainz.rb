module Brainz
  class Brainz
    attr_accessor :cycle_error
    # options
    attr_accessor :learning_rate, :momentum, :max_iterations, :wanted_error
    attr_writer :num_hidden
    attr_accessor :input, :input_order, :output_order
    attr_accessor :input_act, :hidden_act, :output_act
    attr_accessor :num_input, :num_output
    attr_accessor :input_weights, :output_weights, :input_change, :output_change
    attr_reader :algorithm

    def self.current
      @@current
    end

    def initialize(algorithm = :backpropagation)
      self.extend ::Brainz::Algorithms.const_get(algorithm.to_s.capitalize)
    end

    def learning_options(options)
      options.each { |option, value| send("#{option}=", value) }
    end

    def num_hidden
      @num_hidden || (num_input + num_output) * 2 / 3
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

    def format_input(*args)
      if args.first.is_a?(Hash)
        hash = args.first
        if input_order
          input_order.collect { |key| hash[key] }
        else
          self.input_order = hash.keys
          hash.values
        end
      elsif args.any?
        args
      end
    end

    def that(*args)
      self.input = format_input(*args)
      self
    end

    def format_output(*args)
      if args.first.is_a?(Hash)
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
    end

    def is(*args)
      return false if input.nil?

      output = format_output(*args)

      @num_output ||= output.length

      @num_input ||= input.size + 1

      update(input)
      fix_weights(output)
      true
    end

    def evaluate(*args)
      input = format_input(*args)
      #if args.first.is_a?(Hash)
      #  hash = args.first
      #  input_order ? input_order.collect { |key| hash[key] } : hash.values
      #elsif args.any?
      #  args
      #end
      update(input)
    end

    def explain(*args)
      evaluate(*args)
      output_order ? output_act.to_hash(output_order) : output_act
    end

    def guess(*args)
      evaluate(*args)
      if num_output == 1
        output_act.first.round
      else
        max = output_act.max
        unless output_order
          a = 'a'
          self.output_order = [:a] + (num_output - 1).times.collect { a.succ!.to_sym }
        end

        output_order[output_act.index(max)]
      end
    end

    def prepare
      @input_weights = Array.new(num_input) { Array.new(num_hidden) { Kernel.rand(0.4) - 0.2 } }
      @output_weights = Array.new(num_hidden) { Array.new(num_output) { Kernel.rand(4) - 2 } }
      @input_change = Array.new(num_input) { Array.new(num_hidden) { 0 } }
      @output_change = Array.new(num_hidden) { Array.new(num_output) { 0 } }

      @output_act = []
      @hidden_act = []
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