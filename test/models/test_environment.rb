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

  def test_expression_output
    expression = Expression.new(
      :+,
      Variable.new("variable_a"),
      Variable.new("variable_b"),
      output: "variable_c"
    )

    @env.evaluate(expression)
    assert_equal(3, @env.variables["variable_c"])
  end

  def test_expression_update_output
    expression1 = Expression.new(
      :+,
      Variable.new("variable_a"),
      Variable.new("variable_b"),
      output: "variable_a"
    )
    expression2 = Expression.new(
      :+,
      Variable.new("variable_a"),
      Variable.new("variable_b"),
      output: "variable_c"
    )

    @env.evaluate(expression1)
    @env.evaluate(expression2)

    assert_equal(3, @env.variables["variable_a"])
    assert_equal(5, @env.variables["variable_c"])
  end
end
