module Ftest
  def f_test_statistic(x, y, a, b, dispersion_of_rest, f = 1)
    av_y = y.sum / y.length.to_f
    if f == 1
      x.map {|x| (f(a,b,x) - av_y)**2}.sum / dispersion_of_rest.to_f
    else
      x.map {|x| (f_norm(a,b,x) - av_y)**2}.sum / dispersion_of_rest.to_f
    end
  end

  def fisher
    v1 = 1
    v2 = Datum.count - 2
    Datum.fisher_quantile(v1, v2)
  end

  def f_test_conclusion(f_test_statistic)
    f_test_statistic > fisher ? 'регресія значуща' : 'регресія незначуща'
  end

end