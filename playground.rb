require_relative "./util/parser"
require_relative "./models/variable"
require_relative "./models/expression"
require_relative "./models/scalar"
require_relative "./models/environment"

puts "ELO test..."

env = Environment.new(
  "rating_a" => 1000,
  "rating_b" => 1200,
  "scale_factor" => 400,
  "score_a" => 0.5,
  "k_factor" => 32
)

# starting ratings of 2 players
rating_a = Variable.new("rating_a")
rating_b = Variable.new("rating_b")
scale_factor = Variable.new("scale_factor")

rating_difference = Expression.new(:-, rating_b, rating_a)
exponent = Expression.new(:/, rating_difference, scale_factor)
denominator = Expression.new(
  :+,
  Scalar.new(1),
  Expression.new(:**, Scalar.new(10), exponent)
)
expected_probability_a = Expression.new(:/, Scalar.new(1), denominator)

k_factor = Variable.new("k_factor")
# [0, 1] where 0 is loss, 1 is win, 0.5 is draw
score_a = Variable.new("score_a")
k_multiplier = Expression.new(:-, score_a, expected_probability_a)
rating_delta = Expression.new(:*, k_factor, k_multiplier)
rating_a_new = Expression.new(:+, rating_a, rating_delta)

puts "Testing #to_s and evaluation..."
puts rating_a_new
puts env.evaluate(rating_a_new)

puts "Testing serialization and deserialization..."
json_string = rating_a_new.to_json(pretty: true)
puts json_string
parsed_expression = Util::Parser.from_json(json_string)
puts parsed_expression
