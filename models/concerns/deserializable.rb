require "json"

module Concerns
  module Deserializable
    # @param json [String, Hash]
    def from_json(json)
      json = JSON.parse(json) if json.is_a?(String)

      case json["object"]
      when Expression.name
        operator = json["operator"].to_sym
        operands_json = json["operands"]
        operands = operands_json.map do |operand_json|
          operand_klass = const_get(operand_json["object"])
          operand_klass.from_json(operand_json)
        end

        Expression.new(operator, *operands)
      when Variable.name
        Variable.new(json["name"], json["value"])
      when Scalar.name
        Scalar.new(json["value"])
      end
    end
  end
end
