class Environment
  MissingVariableError = Class.new(StandardError)

  attr_reader :variables

  # @param variables [Hash]
  def initialize(**variables)
    @variables = variables
  end

  # @param object [Expression, Variable, Scalar]
  def evaluate(object)
    case object
    when Scalar
      object.value
    when Variable
      variables.fetch(object.name) do
        raise MissingVariableError, "Environment missing variable #{object}."
      end
    when Expression
      object.operands.map { |operand| evaluate(operand) }
                     .reduce(object.operator)
    end
  end
end
