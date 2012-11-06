require 'brainz'

# SIGN function

brainz = Brainz::Brainz.new

brainz.teach do |iteration, error|
  that(1).is(1)
  that(10).is(1)
  that(90).is(1)
  that(-1).is(-1)
  that(-20).is(-1)
  that(-4).is(-1)
  that(0).is(0)
  p "error_rate = #{'%.3f' % error || 0 } after #{iteration} iterations"
end

(-100..100).each do |test_value|
  puts "Error with (#{test_value}) " if brainz.guess(test_value) != (test_value > 0 ? 1 : test_value < 0 ? -1 : 0)
end

puts "sign(0) = #{brainz.guess(0)}, #{brainz.guess(0) == 0}"
puts "sign(-1) = #{brainz.guess(-1)}, #{brainz.guess(-1) == -1}"
puts "sign(1) = #{brainz.guess(1)}, #{brainz.guess(1) == 1}"
puts "sign(22) = #{brainz.guess(22)}, #{brainz.guess(22) == 1}"
puts "sign(-100) = #{brainz.guess(-100)}, #{brainz.guess(-100) == -1}"
puts "sign(6) = #{brainz.guess(6)}, #{brainz.guess(6) == 1}"
