require_relative '../lib/brainz'

# XOR problem

brainz = Brainz::Brainz.new

brainz.teach do |iteration, error|
  that(a: 1, b: 1).is(0)
  that(1, 0).is(1)
  that(0, 1).is(1)
  that(0, 0).is(0)
  p "error_rate = #{'%.3f' % error || 0 } after #{iteration} iterations" if iteration % 25 == 0
end

puts "0 xor 0 = #{brainz.explain(a: 0, b: 0)}, #{brainz.explain(a: 0, b: 0) == 0}"
puts "0 xor 1 = #{brainz.explain(a: 0, b: 1)}, #{brainz.explain(a: 0, b: 1) == 1}"
puts "1 xor 1 = #{brainz.explain(a: 1, b: 1)}, #{brainz.explain(a: 1, b: 1) == 0}"
puts "1 xor 0 = #{brainz.explain(a: 1, b: 0)}, #{brainz.explain(a: 1, b: 0) == 1}"