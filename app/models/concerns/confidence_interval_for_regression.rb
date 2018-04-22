module ConfidenceIntervalForRegression
  def top(a, dispersion_a, b, dispersion_b, cov_a_b, x)
    y_reg_x , sqrt_y_reg_x_dispersion = values_for_regression_interval(a, dispersion_a, b, dispersion_b, cov_a_b, x)
    y_reg_x + Datum::STUDENT_QUANTILE * sqrt_y_reg_x_dispersion
  end

  def bottom(a, dispersion_a, b, dispersion_b, cov_a_b, x)
    y_reg_x , sqrt_y_reg_x_dispersion = values_for_regression_interval(a, dispersion_a, b, dispersion_b, cov_a_b, x)
    y_reg_x - Datum::STUDENT_QUANTILE * sqrt_y_reg_x_dispersion
  end

  def norm_top(a, b, x, dispersion_b)
    y_reg_x , sqrt_y_reg_x_dispersion = norm_values_for_regression_interval(a, b, x, dispersion_b)
    y_reg_x + Datum::STUDENT_QUANTILE * sqrt_y_reg_x_dispersion
  end

  def norm_bottom(a, b, x, dispersion_b)
    y_reg_x , sqrt_y_reg_x_dispersion = norm_values_for_regression_interval(a, b, x, dispersion_b)
    y_reg_x - Datum::STUDENT_QUANTILE * sqrt_y_reg_x_dispersion
  end

  private

  def norm_values_for_regression_interval(a, b, x, dispersion_b)
    y_reg_x = f_norm(a, b, x)
    n = Datum.count
    dispersion_rest = sum_rest(a, b) / n
    av_x = Datum.average(:x)
    sqrt_y_reg_x_dispersion = Math.sqrt(dispersion_rest / n + dispersion_b * (x - av_x)**2)
    [y_reg_x , sqrt_y_reg_x_dispersion]
  end

  def values_for_regression_interval(a, dispersion_a, b, dispersion_b, cov_a_b, x)
    y_reg_x = f(a, b, x)
    ln_x = Math.log(x)
    sqrt_y_reg_x_dispersion = (dispersion_a + 2 * ln_x * cov_a_b + ln_x**2 * dispersion_b)**1/2.0
    [y_reg_x , sqrt_y_reg_x_dispersion]
  end

end