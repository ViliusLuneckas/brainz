module MathUtils
  def sigmoid(x)
    Math.tanh(x)
  end

  def d_sigmoid(y)
    1.0 - y ** 2
  end
end