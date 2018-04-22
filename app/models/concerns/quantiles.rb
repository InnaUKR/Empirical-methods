module Quantiles

  module NormalDistribution
    FIRST_KIND_ERROR = 0,05
    C0 = 2.515517
    C1 = 0.802853
    C2 = 0.010328
    D1 = 1.432788
    D2 = 0.1892659
    D3 = 0.001308
    T = Math.sqrt(-2.0 * Math.log10(FIRST_KIND_ERROR))

    def normal_distribution
      -(T - (
      (C0 + C1 * T + C2 * T**2) /
          1.0 + D1 * T + D2 * T**2 + D3 * T**3
      ))
    end

  end

  module Student
  end

end