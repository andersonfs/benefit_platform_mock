class AddStatusFieldToTransaction < ActiveRecord::Migration[8.0]
  def change
    add_column :transactions, :status, :string
  end
end
