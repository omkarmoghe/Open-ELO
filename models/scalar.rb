require_relative "./concerns/serializable.rb"

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
