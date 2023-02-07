class Variable
  attr_reader :name, :value

  def initialize(name, value)
    @name = name
    @value = value
  end

  def to_s
    "#{name}[#{value}]"
  end
end
