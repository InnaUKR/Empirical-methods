class Datum < ApplicationRecord
  require 'csv'

  def self.import!(file)
    Datum.delete_all
    CSV.foreach(file.path, headers: false) do |row|
      p datum_array = row.first.split("\s")
      Datum.create(x: datum_array.first,y:datum_array.last)
    end
  end

  class << self
    def average_x
      sum(:x).to_f / count
    end
    def average_y
      sum(:y).to_f / count
    end
  end
end
