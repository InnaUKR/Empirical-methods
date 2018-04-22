module EvenCorrelationCoefficient

  def even_value
    av_x = average(:x)
    av_y = average(:y)
    av_xy = average_xy
    ((av_xy - av_x * av_y) /
        (medium_square(:x) * medium_square(:y))).round(Datum::ROUND_NUMBER)
  end

  def even_statistic
    ((even_value * Math.sqrt(count - 2.0)) / Math.sqrt(1.0 - even_value**2)).to_f.round(4)
  end

  def even_interval
    point_value = even_value
    datum_length = count
    value_part = point_value + (
    (point_value * (1.0 - point_value**2)) /
        (2.0 * datum_length)
    )
    quantile_part = Datum::NORMAL_QUANTILE * (
    (1.0 - point_value**2) /
        Math.sqrt(datum_length - 1.0)
    )
    confidence_interval(value_part, quantile_part)
  end

  private
  def average_xy
    sum('x * y') / count
  end
end