module EvenCorrelationCoefficient
  def value
    av_x = Datum.average(:x)
    av_y = Datum.average(:y)
    p av_xy = Datum.sum(:x*:y)/Datum.count
  end
end