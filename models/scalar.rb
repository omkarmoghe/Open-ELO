require_relative "./concerns/serializable"
require_relative "./concerns/deserializable"

class Scalar < Variable
  include Concerns::Serializable
  extend Concerns::Deserializable

  def initialize(value)
    super(value.to_s, value)
  end

  def to_s
    name
  end

  def as_json
    super.merge(
      value: value
    )
  end
end
