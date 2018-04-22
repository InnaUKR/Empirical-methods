module SpearmanCoefficient
  extend ActiveSupport::Concern

  def spirman_value
    n = Datum.count
    x_rank_coeff = bunch_coefficient(:x_rank)
    y_rank_coeff = bunch_coefficient(:y_rank)
    n_ = n * (n**2 -1) / 6.0
    numerator = (n_ - rank_difference_square - x_rank_coeff - y_rank_coeff)
    denominator = Math.sqrt((n_ - 2 * x_rank_coeff)*(n_ - 2 * y_rank_coeff))
    (
      numerator / denominator.to_f
    ).to_f.round(Datum::ROUND_NUMBER)
  end
  def spirman_statistic
    n = Datum.count
    spirman = spirman_value
    (
      spirman * Math.sqrt(n - 2) /
        Math.sqrt(1 - spirman**2)
    ).to_f.round(Datum::ROUND_NUMBER)
  end

  private
  def rank_difference_square
    Datum.pluck(:x_rank, :y_rank).sum{|ranks| (ranks.first - ranks.last)**2}
  end
  def elements_number_in_bunch(db_field)
    Datum.select(db_field).group(db_field).having("count(*) > 1").size.values
  end
  def bunch_coefficient(db_field)
    arr_elements_number_in_bunch = elements_number_in_bunch(db_field)
    arr_elements_number_in_bunch.sum{|el| el**3 - el} / 12.0
  end
end