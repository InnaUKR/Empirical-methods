module RegressionCoefficient
  def f(a, b, x)
    a + b * Math.log(x)
  end

  def f_data_set(a, b, x_array)
    x_array.uniq.map{ |x| [x, f(a, b, x)]}.sort
  end

  def a(x_array, y_array, b)
    y = Datum.average(:y)
    lnx = average_ln_n(x_array)

    y - b * lnx
  end

  def b(x_array, y_array)
    ylnx = average_yln_x(x_array, y_array)
    y = Datum.average(:y)
    lnx = average_ln_n(x_array)
    sqrt_lnx = average_sqrt_ln_n(x_array)
    lnx_in_sqrt = lnx**2

    (ylnx - y * lnx) / (sqrt_lnx - lnx_in_sqrt)
  end

  def dispersion_a(a, b, x_array)
    s_rest = dispersion_of_rest(a, b)
    sqrt_lnx = sqrt_ln_x(x_array)
    n = Datum.count
    ln_x = ln_x(x_array)
    (s_rest * sqrt_lnx) / (n * sqrt_lnx - ln_x**2).to_f
  end

  def dispersion_b(a, b, x_array)
    s_rest = dispersion_of_rest(a, b)
    n = Datum.count
    sqrt_lnx = sqrt_ln_x(x_array)
    ln_x = ln_x(x_array)
    (s_rest * n) / (n * sqrt_lnx - ln_x**2).to_f
  end

  def cov_a_b(a, b, x_array)
    s_rest = dispersion_of_rest(a, b)
    n = Datum.count
    sqrt_lnx = sqrt_ln_x(x_array)
    ln_x = ln_x(x_array)
    - (s_rest * ln_x ) / (n * sqrt_lnx - ln_x**2).to_f
  end

  def interval_a(x_array, y_array)
    b = b(x_array, y_array)
    a = a(x_array, y_array, b)
    dispersion_a = dispersion_a(a, b, x_array)
    interval(a, dispersion_a)
  end

  def interval_b(x_array, y_array)
    b = b(x_array, y_array)
    a = a(x_array, y_array, b)
    dispersion_b = dispersion_b(a, b, x_array)
    interval(b, dispersion_b)
  end

  def statistic_a(x_array, y_array)
    b = b(x_array, y_array)
    a = a(x_array, y_array, b)
    dispersion_a = dispersion_a(a, b, x_array)
    a / Math.sqrt(dispersion_a)
  end

  def statistic_b(x_array, y_array)
    b = b(x_array, y_array)
    a = a(x_array, y_array, b)
    dispersion_b = dispersion_b(a, b, x_array)
    b / Math.sqrt(dispersion_b)
  end

  def significant_a(x_array, y_array)
    statistic = statistic_a(x_array, y_array)
    statistic(statistic)
  end

  def significant_b(x_array, y_array)
    statistic = statistic_b(x_array, y_array)
    statistic(statistic)
  end

  def dispersion_of_rest(a, b)
    p = 2
    sum_rest(a, b) / ( Datum.count - (p+1) ).to_f
  end

  private

  def statistic(statistic)
    t = Datum.student_distribution
    statistic.abs > t ? '!=0' : '=0'
  end

  def interval(coef, coef_dispersion)
    t = Datum.student_distribution
    left_border = coef - t * coef_dispersion**(1/2.0)
    right_border = coef + t * coef_dispersion**(1/2.0)
    [left_border.to_f.round(Datum::ROUND_NUMBER), right_border.to_f.round(Datum::ROUND_NUMBER)]
  end

  def sum_rest(a, b)
    Datum.all.sum{ |el| (el.y - f(a, b, el.x))**2 }
  end

  def average_ln_n(x_array)
    ln_x(x_array) / x_array.length.to_f
  end

  def ln_x(x_array)
    x_array.sum{|x| Math.log(x)}
  end

  def average_sqrt_ln_n(x_array)
    sqrt_ln_x(x_array) / x_array.length.to_f
  end

  def sqrt_ln_x(x_array)
    x_array.sum{|x| (Math.log(x))**2}
  end

  def average_yln_x(x_array, y_array)
    sum = 0
    x_array.each_with_index{|x, index| sum += y_array[index]* Math.log(x)}
    sum / x_array.length.to_f
  end
end