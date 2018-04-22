class Datum < ApplicationRecord
  ROUND_NUMBER = 4

  extend ConfidenceInterval
  extend Import
  extend Quantiles
  NORMAL_QUANTILE = normal_distribution.round(ROUND_NUMBER)
  STUDENT_QUANTILE = student_distribution.round(ROUND_NUMBER)
  #normal_distribution #1.96
  extend Statistic
  extend EvenCorrelationCoefficient
  extend SpearmanCoefficient
  extend KendallCorrelation
  extend RelationCorrelation
  extend Significance
  extend RegressionCoefficient
  extend NormRegressionCoefficient
  extend ConfidenceIntervalForRegression
  extend ConfidenceIntervalForPredictedValues
  extend Ftest
  extend DiagnosticDiagram
end
