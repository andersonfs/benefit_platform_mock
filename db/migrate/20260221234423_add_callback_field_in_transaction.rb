class AddCallbackFieldInTransaction < ActiveRecord::Migration[8.0]
  def change
    add_column :transactions, :authorization_callback_url, :string
  end
end
