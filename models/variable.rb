require_relative "./concerns/serializable"
require_relative "./concerns/deserializable"

class Variable
  include Concerns::Serializable
  extend Concerns::Deserializable

  attr_reader :name, :value

  def initialize(name, value)
    @name = name
    @value = value
  end

  def to_s
    "#{name}[#{value}]"
  end

  def as_json
    super.merge(
      name: name,
      value: value
    )
  end
end
