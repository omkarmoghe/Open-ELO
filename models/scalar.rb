require_relative "./variable"
require_relative "./concerns/serializable"

class Scalar < Variable
  include Concerns::Serializable

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
