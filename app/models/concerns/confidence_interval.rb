module ConfidenceInterval
  def confidence_interval(left_part, right_part)
    left_border = left_part - right_part
    right_border = left_part + right_part
    [left_border, right_border]
  end
end