class Scalar < Variable
  def initialize(value)
    super(value.to_s, value)
  end

  def to_s
    name
  end
end
