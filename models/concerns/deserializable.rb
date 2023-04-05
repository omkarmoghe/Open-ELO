require "json"

module Concerns
  module Deserializable
    # @param json [String, Hash]
    def from_json(json)
      json = JSON.parse(json) if json.is_a?(String)

      klass = json["object"].safe_constantize
      case klass
      when Expression
        operator = json["operator"].to_sym
        operands_json = json["operands"]
        # TODO(@omkarmoghe)
        # klass.new(operator)
      when Variable
        klass.new(json["name"], json["value"])
      when Scalar
        klass.new(json["value"])
      end
    end
  end
end
