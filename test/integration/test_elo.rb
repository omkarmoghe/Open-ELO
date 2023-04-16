require "minitest/autorun"

require_relative "../../models/environment"
require_relative "../../models/variable"
require_relative "../../models/expression"
require_relative "../../models/scalar"

class TestElo < Minitest::Test
  def setup
    @env = Environment.new(
      "rating_a" => 1000,
      "rating_b" => 1200,
      "scale_factor" => 400,
      "score_a" => 0.5,
      "k_factor" => 32
    )
  end

  def test_elo
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

    assert_equal(1016.0, @env.evaluate(rating_a_new))
  end

  def test_elo_no_local_variables
    rating_a_new = @env.evaluate(
      # starting ratings of 2 players
      Expression.new(:-, Variable.new("rating_b"), Variable.new("rating_a"), output: "rating_difference"),
      Expression.new(:/, Variable.new("rating_difference"), Variable.new("scale_factor"), output: "exponent"),
      Expression.new(
        :+,
        Scalar.new(1),
        Expression.new(:**, Scalar.new(10), Variable.new("exponent")),
        output: "denominator"
      ),
      Expression.new(:/, Scalar.new(1), Variable.new("denominator"), output: "expected_probability_a"),

      # [0, 1] where 0 is loss, 1 is win, 0.5 is draw
      Expression.new(:-, Variable.new("score_a"), Variable.new("expected_probability_a"), output: "k_multiplier"),
      Expression.new(:*, Variable.new("k_factor"), Variable.new("k_multiplier"), output: "rating_delta"),
      Expression.new(:+, Variable.new("rating_a"), Variable.new("rating_delta"), output: "rating_a_new")
    )

    assert_equal(1016.0, rating_a_new)
  end
end
