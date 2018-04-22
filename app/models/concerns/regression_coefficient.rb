
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
    (s_rest * sqrt_lnx) / (n * ln_x - ln_x**2).to_f
  end

  def dispersion_b(a, b, x_array)
    s_rest = dispersion_of_rest(a, b)
    n = Datum.count
    ln_x = ln_x(x_array)
    (s_rest * n) / (n * ln_x - ln_x**2).to_f
  end

  private

  def dispersion_of_rest(a, b)
    p = 2
    sum_rest(a, b) / ( Datum.count - (p + 1) ).to_f
  end

  def sum_rest(a, b)
    Datum.all.sum{ |el| el.y - f(a, b, el.x) }
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
    x_array.sum{|x| Math.log(x)**2}
  end

  def average_yln_x(x_array, y_array)
    sum = 0
    x_array.each_with_index{|x, index| sum += y_array[index]* Math.log(x)}
    sum / x_array.length.to_f
  end
