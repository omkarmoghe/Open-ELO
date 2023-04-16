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
      variables.fetch(object.name) do |key|
        raise MissingVariableError, "Environment missing variable #{key}."
      end
    when Expression
      value = object.operands.map { |operand| evaluate(operand) }
                             .reduce(object.operator)

      if object.output
        variables[object.output] = value
      end

      value
    end
  end
end
