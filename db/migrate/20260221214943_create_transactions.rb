class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.string :external_id
      t.string :recipient
      t.integer :amount
      t.string :unit
      t.string :customer_id

      t.timestamps
    end
  end
end
