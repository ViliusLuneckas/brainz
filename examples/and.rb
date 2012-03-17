require_relative '../lib/brainz'

# AND problem

brainz = Brainz::Brainz.new

brainz.teach do |iteration, error|
  that(1, 1).is(1)
  that(1, 0).is(0)
  that(0, 1).is(0)
  that(0, 0).is(0)
  p "error_rate = #{'%.3f' % error || 0 } after #{iteration} iterations" if iteration % 10 == 0
end

puts "0 and 0 = #{brainz.guess(a: 0, b: 0)}, #{brainz.guess(a: 0, b: 0) == 0}"
puts "0 and 1 = #{brainz.guess(a: 0, b: 1)}, #{brainz.guess(a: 0, b: 1) == 0}"
puts "1 and 1 = #{brainz.guess(a: 1, b: 1)}, #{brainz.guess(a: 1, b: 1) == 1}"
puts "1 and 0 = #{brainz.guess(a: 1, b: 0)}, #{brainz.guess(a: 1, b: 0) == 0}"
