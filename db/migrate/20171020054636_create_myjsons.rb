class CreateMyjsons < ActiveRecord::Migration[5.1]
  def change
    create_table :myjsons do |t|
      t.string :form
      t.string :form_name
      t.integer :order_id
      t.integer :price
      t.string :product1
      t.string :product2
      t.string :name
      t.string :phone
      t.string :email
      t.string :comment
      t.string :address
      t.string :payment


      t.timestamps
    end
  end
end
