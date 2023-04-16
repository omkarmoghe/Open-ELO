require "minitest/autorun"
require_relative "../../models/environment"
require_relative "../../models/variable"
require_relative "../../models/scalar"

class TestEnvironment < Minitest::Test
  def setup
    @env = Environment.new(
      "variable_a" => 1,
      "variable_b" => 2
    )
  end

  def test_evaluate_variables
    assert_equal(1, @env.evaluate(Variable.new("variable_a")))
    assert_equal(2, @env.evaluate(Variable.new("variable_b")))
  end

  def test_evaluate_missing_variable
    assert_raises(Environment::MissingVariableError) do
      @env.evaluate(Variable.new("missing_variable"))
    end
  end

  def test_scalar
    assert_equal(1, @env.evaluate(Scalar.new(1)))
  end

  def test_expression
    expression = Expression.new(
      :+,
      Variable.new("variable_a"),
      Variable.new("variable_b")
    )

    assert_equal(3, @env.evaluate(expression))
  end
end
