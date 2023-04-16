require "minitest/autorun"
require_relative "../../models/expression"

class TestExpression < Minitest::Test
  def test_minimum_operands
    assert_raises(Expression::InvalidOperandError) do
      Expression.new(:+, Scalar.new(1))
    end
  end

  def test_allowed_operands
    assert_raises(Expression::InvalidOperandError) do
      Expression.new(:+, 1, 2)
    end
  end
end
