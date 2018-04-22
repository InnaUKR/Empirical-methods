module RelationCorrelation
  def count_step(classes_number)
    (Datum.last.x - Datum.first.x) / classes_number.to_f
  end
  def count_classes_number
    (1 + 1.44 * Math.log10(count)).round(0)
  end
  def find_y_i_j
    classes_number = count_classes_number
    step =count_step(classes_number)
    x_i = find_borders
    y = []
    (0...x_i.length-2).each do |i|
      p y << Datum.where(:x=>(x_i[i]..x_i[i+1]))
    end
    y << Datum.where(:x=>(x_i[x_i.length-2]..x_i[x_i.length-1]))
    y
  end
  def find_borders
    classes_number = count_classes_number
    step =count_step(classes_number)
    x_i = []
    (1..classes_number+1).each do |i|
      x_i << Datum.first.x + (i - 1)* step
    end
    x_i
  end
  def average_y_i(y_i)
    y_i.sum(&:y) / y_i.length.to_f
  end
  def average_y(y)
    y.sum{ |y_i| y_i.length * average_y_i(y_i)} / Datum.count.to_f
  end

  def dispersion_y(y_i_j)
    y = average_y(y_i_j)
    y_i_j.sum do | y_i |
     p y_i.sum{|y_j| (y_j.y - y)**2}
    end
  end
  def relation_value
    y_i_j = find_y_i_j
    y = average_y(y_i_j)
    (
      y_i_j.sum{|y_i| y_i.length * (average_y_i(y_i) - y)**2} / dispersion_y(y_i_j)
    ).to_f.round(Datum::ROUND_NUMBER)
  end
  def relation_statistic
    relation_2 = relation_value
    k = count_classes_number
    n = Datum.count
    (
      (relation_2 / (k-1)) / ((1 - relation_2)/(n - k).to_f)
    ).round(Datum::ROUND_NUMBER)
  end
  def count_fisher_quantile
    k = count_classes_number
    n = Datum.count
    v1 = (k - 1)
    v2 = (n - k)
    fisher_quantile(v1, v2)
  end
end