module KendallCorrelation
  def kendall_value
    n = count
    s = kendall_v
    c = bunch_coefficient(:x_rank)
    d = bunch_coefficient(:y_rank)
    (
      s / Math.sqrt((n/2.0 * (n-1) -c) * (n/2.0 * (n-1) -d))
    ).to_f.round(Datum::ROUND_NUMBER)
  end
  def kendall_statistic
    n = count
    (
      (3 * kendall_value * Math.sqrt(n* (n-1))) /
      (Math.sqrt(2*(2 * n + 5))).to_f
    ).to_f.round(Datum::ROUND_NUMBER)
  end
  private
  def kendall_v
    result = 0
    data = Datum.all.to_a
    (0...data.length).each do |i|
      data[i]
      (i+1...data.length).each do |j|
        if data[i].x_rank == data[j].x_rank
          next
        elsif data[i].y_rank < data[j].y_rank
          result += 1
        elsif data[i].y_rank > data[j].y_rank
          result -= 1
        end
      end
    end
    result
  end

  def elements_number_in_bunch(db_field)
    Datum.select(db_field).group(db_field).having("count(*) > 1").size.values
  end
  def bunch_coefficient(db_field)
    arr_elements_number_in_bunch = elements_number_in_bunch(db_field)
    arr_elements_number_in_bunch.sum{|el| el * (el -1)} / 2.0
  end
end