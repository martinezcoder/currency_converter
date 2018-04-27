class AmountHelper
  # five decimals precision
  DECIMAL_PRECISION=100000

  class << self
    def to_integer(raw_amount)
      (Float(raw_amount) * DECIMAL_PRECISION).to_i
    end

    def to_float(integer_amount)
      (Float(integer_amount) / DECIMAL_PRECISION)
    end
  end
end
