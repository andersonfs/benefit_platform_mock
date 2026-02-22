class AddProductIdFieldInTransaction < ActiveRecord::Migration[8.0]
  def change
    add_column :transactions, :product_id, :string
  end
end
