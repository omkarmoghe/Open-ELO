require "minitest/autorun"
require_relative "../../util/parser"
require_relative "../../models/scalar"

class TestParser < Minitest::Test
  def test_variable
    json = <<~JSON
      {
        "object": "Variable",
        "name": "score_a",
        "value": 0.5
      }
    JSON

    result = Util::Parser.from_json(json)

    assert_kind_of(Variable, result)
    assert_equal("score_a", result.name)
    assert_equal(0.5, result.value)
  end

  def test_scalar
    json = <<~JSON
      {
        "object": "Scalar",
        "name": "10",
        "value": 10
      }
    JSON

    assert_kind_of(Scalar, Util::Parser.from_json(json))
  end

  def test_expression
    json = <<~JSON
      {
        "object": "Expression",
        "operator": "-",
        "operands": [
          {
            "object": "Variable",
            "name": "rating_b",
            "value": 1200
          },
          {
            "object": "Variable",
            "name": "rating_a",
            "value": 1000
          }
        ]
      }
    JSON

    result = Util::Parser.from_json(json)

    assert_kind_of(Expression, result)
    assert_equal(:-, result.operator)
    result.operands.each do |operand|
      assert_kind_of(Variable, operand)
    end
  end

  def test_unknown_object
    json = <<~JSON
      {
        "object": "UnknownObject",
        "name": "10",
        "value": 10
      }
    JSON

    assert_raises(Util::Parser::DeserializationError) do
      Util::Parser.from_json(json)
    end
  end

  def test_invalid_json
    assert_raises(Util::Parser::DeserializationError) do
      Util::Parser.from_json("abcd")
    end
  end
end
