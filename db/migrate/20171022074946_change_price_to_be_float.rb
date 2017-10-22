class ChangePriceToBeFloat < ActiveRecord::Migration[5.1]
  def change
    change_column :myjsons, :price, :float
  end
end
