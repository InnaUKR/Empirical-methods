class DataController < ApplicationController

  def index
    @data = Datum.all
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
