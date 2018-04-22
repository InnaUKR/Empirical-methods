module NormRegressionCoefficient
  def f_norm(a, b, x)
    a + b * x
  end

  def f_norm_data_set(a, b, x_array)
    x_array.uniq.map{ |x| [x, f_norm(a, b, x)]}.sort
  end

  def a_norm(x_array, y_array, b)
    y = Datum.average(:y)
    x = Datum.average(:x)

    y - b * x
  end

  def b_norm(x_array, y_array)
    p av_xy = xy_av_norm(x_array, y_array)
    p y = Datum.average(:y)
    p x = Datum.average(:x)
    x_sqrt = x_sqrt_norm(x_array)

    (av_xy - x * y) / (x_sqrt - x**2).to_f
  end

  def x_sqrt_norm(x)
    x.sum {|x| x**2 } / x.length.to_f
  end

  def xy_av_norm(x, y)
    x.each_with_index {|x, i| x * y[i]}.sum
  end

  def norm_dispersion_of_rest(a, b)
    p = 2
    sum_rest(a, b) / ( Datum.count - (p+1) ).to_f
  end

  def sum_rest(a, b)
    Datum.all.sum{ |el| (el.y - f_norm(a, b, el.x))**2 }
  end

  def norm_dispersion_a(a, b, x_array)
    s_rest = dispersion_of_rest(a, b)
    av_x = Datum.average(:x)
    dispersion_x = norm_dispersion_x(x_array)
    n = Datum.count.to_f
    s_rest * (1 / n + av_x**2 / (n * dispersion_x).to_f)
  end

  def norm_dispersion_x(x_array)
    av_x = Datum.average(:x)
    x_array.sum{|x| (x-av_x)**2} / x_array.length.to_f
  end

  def norm_dispersion_b(a, b, x_array)
    s_rest = dispersion_of_rest(a, b)
    n = Datum.count
    dispersion_x = norm_dispersion_x(x_array)
    s_rest / (n * dispersion_x).to_f
  end

  def norm_interval_a(x_array, y_array)
    b = b_norm(x_array, y_array)
    a = a_norm(x_array, y_array, b)
    dispersion_a = norm_dispersion_a(a, b, x_array)
    norm_interval(a, dispersion_a)
  end

  def norm_interval_b(x_array, y_array)
    b = b_norm(x_array, y_array)
    a = a_norm(x_array, y_array, b)
    dispersion_b = norm_dispersion_b(a, b, x_array)
    norm_interval(b, dispersion_b)
  end

  def norm_interval(coef, coef_dispersion)
    t = Datum.student_distribution
    left_border = coef - t * coef_dispersion**(1/2.0)
    right_border = coef + t * coef_dispersion**(1/2.0)
    [left_border.to_f.round(Datum::ROUND_NUMBER), right_border.to_f.round(Datum::ROUND_NUMBER)]
  end

  def norm_cov_a_b(a, b, x_array)
      s_rest = norm_dispersion_of_rest(a, b)
      n = Datum.count
      av_x = x_array.sum
      norm_dispersion_x = norm_dispersion_x(x_array)
      - (s_rest * av_x ) / (n * norm_dispersion_x).to_f
  end

  def norm_statistic_a(x_array, y_array)
    b = b_norm(x_array, y_array)
    a = a_norm(x_array, y_array, b)
    dispersion_a = norm_dispersion_a(a, b, x_array)
    a / Math.sqrt(dispersion_a)
  end

  def norm_statistic_b(x_array, y_array)
    b = b_norm(x_array, y_array)
    a = a_norm(x_array, y_array, b)
    dispersion_b = norm_dispersion_b(a, b, x_array)
    b / Math.sqrt(dispersion_b)
  end

  def norm_significant_a(x_array, y_array)
    statistic = norm_statistic_a(x_array, y_array)
    statistic(statistic)
  end

  def norm_significant_b(x_array, y_array)
    statistic = norm_statistic_b(x_array, y_array)
    statistic(statistic)
  end
end