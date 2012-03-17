require_relative '../lib/brainz'

# XOR problem

brainz = Brainz::Brainz.new

brainz.teach(learning_rate: 0.2, momentum: 0.01, wanted_error: 0.01, max_iterations: 2000) do |iteration, error|
  that(a: 1, b: 1).is(0)
  that(1, 0).is(1)
  that(0, 1).is(1)
  that(0, 0).is(0)
end

p "Learning took #{brainz.last_iterations}, error: #{brainz.error}, time: #{brainz.learning_time} s."