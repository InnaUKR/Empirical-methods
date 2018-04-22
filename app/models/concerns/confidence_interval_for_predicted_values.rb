module ConfidenceIntervalForPredictedValues
  def top_predicted_value(a, dispersion_a, b, dispersion_b, cov_a_b, x, dispersion_of_rest)
    y_reg_x , res = values_for_values_interval(a, dispersion_a, b, dispersion_b, cov_a_b, x, dispersion_of_rest)
    y_reg_x + Datum::STUDENT_QUANTILE * res
  end

  def bottom_predicted_value(a, dispersion_a, b, dispersion_b, cov_a_b, x, dispersion_of_rest)
    y_reg_x , res= values_for_values_interval(a, dispersion_a, b, dispersion_b, cov_a_b, x, dispersion_of_rest)
    y_reg_x - Datum::STUDENT_QUANTILE * res
  end

  def norm_top_predicted_value(a, dispersion_a, b, dispersion_b, cov_a_b, x, dispersion_of_rest)
    y_reg_x , res = norm_values_for_values_interval(a, dispersion_a, b, dispersion_b, cov_a_b, x, dispersion_of_rest)
    y_reg_x + Datum::STUDENT_QUANTILE * res
  end

  def norm_bottom_predicted_value(a, dispersion_a, b, dispersion_b, cov_a_b, x, dispersion_of_rest)
    y_reg_x , res= norm_values_for_values_interval(a, dispersion_a, b, dispersion_b, cov_a_b, x, dispersion_of_rest)
    y_reg_x - Datum::STUDENT_QUANTILE * res
  end

  private

  def norm_values_for_values_interval(a, dispersion_a, b, dispersion_b, cov_a_b, x, dispersion_of_rest)
    y_reg_x = f_norm(a, b, x)
    n = Datum.count
    dispersion_rest = sum_rest(a, b) / n
    av_x = Datum.average(:x)
    sqrt_y_reg_x_dispersion = Math.sqrt(dispersion_rest / n + dispersion_b * (x - av_x)**2)
    rez = Math.sqrt(sqrt_y_reg_x_dispersion+dispersion_rest)
    [y_reg_x , rez]
  end

  def values_for_values_interval(a, dispersion_a, b, dispersion_b, cov_a_b, x, dispersion_of_rest)
    y_reg_x = f(a, b, x)
    ln_x = Math.log(x)
    rez = (dispersion_a + 2 * ln_x * cov_a_b + ln_x**2 * dispersion_b + dispersion_of_rest)**0.5
    [y_reg_x, rez]
  end
end