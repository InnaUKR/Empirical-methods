class AddRanksToData < ActiveRecord::Migration[5.1]
  def change
    add_column :data, :x_rank, :decimal
    add_column :data, :y_rank, :decimal
  end
end
