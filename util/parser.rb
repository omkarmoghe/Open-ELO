require "json"
require_relative "../models/variable"
require_relative "../models/expression"
require_relative "../models/scalar"

module Util
  class Parser
    DeserializationError = Class.new(StandardError)

    class << self
      # @param json [String, Hash]
      def from_json(json)
        json = JSON.parse(json) if json.is_a?(String)

        case json["object"]
        when Expression.name
          operator = json["operator"].to_sym
          operands_json = json["operands"]
          operands = operands_json.map { |operand_json| from_json(operand_json) }

          Expression.new(operator, *operands)
        when Variable.name
          Variable.new(json["name"], json["value"])
        when Scalar.name
          Scalar.new(json["value"])
        else
          raise DeserializationError, "Object class #{json["object"]} does not support deserialization."
        end
      rescue JSON::ParserError => e
        raise DeserializationError, "Unable to parse JSON: #{e.message}."
      end
    end
  end
end
