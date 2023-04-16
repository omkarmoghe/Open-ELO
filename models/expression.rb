require_relative "./scalar"
require_relative "./variable"
require_relative "./concerns/serializable"

class Expression
  include Concerns::Serializable

  ALLOWED_OPERANDS = [
    Expression,
    Scalar,
    Variable
  ].freeze

  InvalidOperatorError = Class.new(StandardError)
  InvalidOperandError = Class.new(StandardError)

  attr_reader :operator, :operands

  # @param operator [String, Symbol] Mathematical operator to `reduce` the `operands` array with.
  # @param *operands [Variable, Expressions] 2 or more Variables, Scalars, or Expressions
  def initialize(operator, *operands)
    @operator = operator.to_sym
    @operands = operands

    validate!
  end

  def to_s
    "(#{operands.join(" #{operator.to_s} ")})"
  end

  def as_json
    super.merge(
      operator: operator.to_s,
      operands: operands.map(&:as_json)
    )
  end

  private

  def validate!
    raise InvalidOperandError, "Must provide 2 or more operands." unless operands.length >= 2

    unless (operands.map(&:class) - ALLOWED_OPERANDS).empty?
      raise InvalidOperandError, "Operands must be one of #{ALLOWED_OPERANDS.inspect}."
    end

    nil
  end
end
