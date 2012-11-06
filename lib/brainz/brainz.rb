module Brainz
  class Brainz
    attr_reader :network
    attr_accessor :max_iterations, :wanted_error, :momentum, :learning_rate
    attr_accessor :input_order, :output_order, :input

    attr_writer :num_hidden
    attr_reader :num_output, :num_input

    attr_reader :last_iterations

    def self.current
      @@current
    end

    def initialize(algorithm = :backpropagation)
      self.extend ::Brainz::Algorithms.const_get(algorithm.to_s.capitalize)
    end

    def learning_options(options)
      options.each { |option, value| send("#{option}=", value) if respond_to? ("#{option}=")}
    end

    def num_hidden
      @num_hidden || [(num_input + num_output) * 2 / 3]
    end

    def learning_cycle
      old_error = 100.0
      @last_iterations = 0
      max_iterations.times do |i|
        @last_iterations += 1
        if @network
          old_error = @network.mse
          @network.mse = 0
        end

        yield(i, old_error)

        break if @network.mse <= wanted_error
      end
    end

    def learning_time
      @learning_ended - @learning_started
    end

    def teach(options = {})
      @@current = self
      @learning_started = Time.new

      learning_options({momentum: 0.15, learning_rate: 0.5, wanted_error: 0.02, max_iterations: 1000}.merge(options))

      learning_cycle do |iteration, error|
        yield(iteration, error)
      end
      @learning_ended = Time.new
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
      unless input.nil?
        output = format_output(*args)

        @num_output ||= output.length

        @num_input ||= input.size

        update(input)
        fix_weights(output)
      end
    end

    def evaluate(*args)
      input = format_input(*args)
      update(input)
    end

    def explain(*args)
      evaluate(*args)
      output_order ? output_act.to_hash(output_order) : output_act
    end

    def output_act
      @network.output.neurons.collect(&:activation)
    end

    def error
      @network.mse
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
  end
end


def self.method_missing(meth = nil, *args, &block)
  meth == :that ? Brainz::Brainz.current.send(meth, *args) : super
end
