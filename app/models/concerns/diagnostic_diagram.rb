module DiagnosticDiagram
  def diagnostic_diagram_data_set(x, y, a, b, flag = 1)
    res = []
    if flag == 1
      y.each_with_index do |y, index|
        f = f(a, b, x[index])
        e = y - f
        res << [f, e]
      end
    else
      y.each_with_index do |y, index|
        f = f_norm(a, b, x[index])
        e = y - f
        res << [f, e]
      end
    end
    res
  end
end