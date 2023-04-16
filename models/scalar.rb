require_relative "./variable"
require_relative "./concerns/serializable"

class Scalar
  include Concerns::Serializable

  attr_reader :value

  def initialize(value)
    @value = value
  end

  def to_s
    value.to_s
  end

  def as_json
    super.merge(
      value: value
    )
  end
end
