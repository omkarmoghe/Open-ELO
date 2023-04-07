require_relative "./util/parser.rb"
require_relative "./models/variable.rb"
require_relative "./models/expression.rb"
require_relative "./models/scalar.rb"

puts "ELO test..."

# starting ratings of 2 players
rating_a = Variable.new("rating_a", 1000)
rating_b = Variable.new("rating_b", 1200)
scale_factor = Variable.new("scale_factor", 400.0)

rating_difference = Expression.new(:-, rating_b, rating_a)
exponent = Expression.new(:/, rating_difference, scale_factor)
denominator = Expression.new(
  :+,
  Scalar.new(1),
  Expression.new(:**, Scalar.new(10), exponent)
)
expected_probability_a = Expression.new(:/, Scalar.new(1), denominator)

k_factor = Variable.new("k_factor", 32)
# [0, 1] where 0 is loss, 1 is win, 0.5 is draw
score_a = Variable.new("score_a", 0.5)
k_multiplier = Expression.new(:-, score_a, expected_probability_a)
rating_delta = Expression.new(:*, k_factor, k_multiplier)
rating_a_new = Expression.new(:+, rating_a, rating_delta)

puts "Testing #to_s and evaluation..."
puts rating_a_new
puts rating_a_new.value

puts "Testing serialization and deserialization..."
json_string = rating_a_new.to_json(pretty: true)
puts json_string
parsed_expression = Util::Parser.from_json(json_string)
puts parsed_expression
