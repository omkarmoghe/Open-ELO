require_relative "./concerns/serializable.rb"

class Variable
  include Concerns::Serializable

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
