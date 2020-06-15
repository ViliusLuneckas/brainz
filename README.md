# Brainz

Artificial Neural Network Library written in Ruby.

## Supported training algorithms

* Backpropagation

## Installation

Add this line to your application's Gemfile:

    gem 'brainz'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install brainz

## Usage

### Simple example, logical AND operation

    require 'brainz'
    
    brainz = Brainz::Brainz.new
    
    brainz.teach do |iteration, error|
      that(1, 1).is(1)
      that(1, 0).is(0)
      that(0, 1).is(0)
      that(0, 0).is(0)
      p "error_rate = #{'%.3f' % error || 0 } after #{iteration} iterations" if iteration % 10 == 0
    end
    
    puts "0 and 0 = #{brainz.guess(a: 0, b: 0)}"
    puts "0 and 1 = #{brainz.guess(a: 0, b: 1)}"
    puts "1 and 1 = #{brainz.guess(a: 1, b: 1)}"
    puts "1 and 0 = #{brainz.guess(a: 1, b: 0)}"

### Advanced usage, ligical XOR operation

    require 'brainz'

    brainz = Brainz::Brainz.new
    
    # specify number of hidden layers
    # 3 hidden layers with 4, 7 and 3 neurons
    brainz.num_hidden = [4, 7, 3]
    
    # tune learning parameters: learning_rate, momentum, wanted_error (mse)
    brainz.teach(learning_rate: 0.2, momentum: 0.05, wanted_error: 0.01) do |iteration, error|
      that(1, 1).is(0)
      that(1, 0).is(1)
      that(0, 1).is(1)
      that(0, 0).is(0)
    end

    puts "Learning took #{brainz.last_iterations}, error: #{brainz.error}, time: #{brainz.learning_time} s."
