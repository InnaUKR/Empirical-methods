class DataController < ApplicationController
  def index
    @data_x_y = Datum.pluck(:x, :y)
    @x = Datum.pluck(:x)
    @y = Datum.pluck(:y)
    @b = Datum.b(@x, @y)
    @a = Datum.a(@x, @y, @b)
    @dispersion_a = Datum.dispersion_a(@a, @b, @x).round(Datum::ROUND_NUMBER)
    @dispersion_b = Datum.dispersion_b(@a, @b, @x).round(Datum::ROUND_NUMBER)
    @cov_a_b = Datum.cov_a_b(@a, @b, @x).round(Datum::ROUND_NUMBER)
    dispersion_of_rest = Datum.dispersion_of_rest(@a, @b).round(Datum::ROUND_NUMBER)
    @function_values = Datum.f_data_set(@a, @b, @x)
    @top_regression = @x.map{ |x| [ x, Datum.top(@a, @dispersion_a, @b, @dispersion_b, @cov_a_b, x)]}.sort
    @bottom_regression = @x.map{ |x| [ x, Datum.bottom(@a, @dispersion_a, @b, @dispersion_b, @cov_a_b, x)]}.sort
    @top_values = @x.map{|x| [ x, Datum.top_predicted_value(@a, @dispersion_a, @b, @dispersion_b, @cov_a_b, x, dispersion_of_rest )]}.sort
    @bottom_values = @x.map{|x| [ x, Datum.bottom_predicted_value(@a, @dispersion_a, @b, @dispersion_b, @cov_a_b, x, dispersion_of_rest )]}.sort
    @f_test_statistic = Datum.f_test_statistic(@x, @y, @a, @b, dispersion_of_rest).round(Datum::ROUND_NUMBER)
    @fisher = Datum.fisher.round(Datum::ROUND_NUMBER)
    @pirson_value = Datum.even_value
    @diagnostic_diagram_data_set = Datum.diagnostic_diagram_data_set(@x, @y, @a, @b)
  end

  def show_normal_regression
    @data_x_y = Datum.pluck(:x, :y)
    @x = Datum.pluck(:x)
    @y = Datum.pluck(:y)

    @b = Datum.b_norm(@x, @y)
    @a = Datum.a_norm(@x, @y, @b)
    @dispersion_a = Datum.norm_dispersion_a(@a, @b, @x).round(Datum::ROUND_NUMBER)
    @dispersion_b = Datum.norm_dispersion_b(@a, @b, @x).round(Datum::ROUND_NUMBER)
    @cov_a_b = Datum.norm_cov_a_b(@a, @b, @x).round(Datum::ROUND_NUMBER)
    dispersion_of_rest = Datum.norm_dispersion_of_rest(@a, @b).round(Datum::ROUND_NUMBER)

    @function_values = Datum.f_norm_data_set(@a, @b, @x)
    @top_regression = @x.map{ |x| [ x, Datum.norm_top(@a, @b, x, @dispersion_b)]}.sort
    @bottom_regression = @x.map{ |x| [ x, Datum.norm_bottom(@a, @b, x, @dispersion_b)]}.sort
    @top_values = @x.map{|x| [ x, Datum.norm_top_predicted_value(@a, @dispersion_a, @b, @dispersion_b, @cov_a_b, x, dispersion_of_rest )]}.sort
    @bottom_values = @x.map{|x| [ x, Datum.norm_bottom_predicted_value(@a, @dispersion_a, @b, @dispersion_b, @cov_a_b, x, dispersion_of_rest )]}.sort

    @f_test_statistic = Datum.f_test_statistic(@x, @y, @a, @b, dispersion_of_rest, 2).round(Datum::ROUND_NUMBER)
    @fisher = Datum.fisher.round(Datum::ROUND_NUMBER)
    @pirson_value = Datum.even_value
    @diagnostic_diagram_data_set = Datum.diagnostic_diagram_data_set(@x, @y, @a, @b, 2)
  end

  def import
    Datum.import!(params[:file])
    redirect_to data_path, notice: 'File imported!'
  end

  private
    def set_datum
      @datum = Datum.find(params[:id])
    end

    def datum_params
      params.require(:datum).permit(:x, :y, :file)
    end
end
