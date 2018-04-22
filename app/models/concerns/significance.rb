module Significance
  def even_significance
    significance(Datum.even_statistic)
  end

  def spirman_significance
    significance(Datum.spirman_statistic)
  end

  def relation_significance
    significance(Datum.relation_statistic, Datum.count_fisher_quantile)
  end

  def kendall_significance
    significance(Datum.kendall_statistic, Datum::NORMAL_QUANTILE)
  end


  def significance(statistic, quantile = Datum::STUDENT_QUANTILE)
    statistic.abs > quantile ? '+' : '-'
  end
end