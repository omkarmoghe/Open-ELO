require_relative "./scalar.rb"
require_relative "./variable.rb"

class Expression
  ALLOWED_OPERANDS = [
    Expression,
    Scalar,
    Variable
  ].freeze

  InvalidOperatorError = Class.new(StandardError)
  InvalidOperandError = Class.new(StandardError)

  attr_reader :operator, :operands

  # @param operator [String, Symbol] Mathematical operator to `reduce` the `operands` array with.
  # @param *operands [Variable, Expressions] 2 or more
  def initialize(operator, *operands)
    @operator = operator.to_sym
    @operands = operands

    validate!
  end

  def value
    @value ||= evaluate
  end

  def to_s
    "(#{operands.join(" #{operator.to_s} ")})"
  end

  private

  def validate!
    raise InvalidOperandError, "Must provide 2 or more operands." unless operands.length >= 2

    unless (operands.map(&:class) - ALLOWED_OPERANDS).empty?
      raise InvalidOperandError, "Operands must be one of [Variable, Expression]."
    end

    unless operands.all? { |o| o.value.respond_to?(operator) }
      raise InvalidOperatorError, "One or more operands do not support the operator."
    end

    nil
  end

  def evaluate
    operands.map(&:value).reduce(operator)
  end
end
