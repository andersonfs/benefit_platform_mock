class AddCompanyFieldsToTransaction < ActiveRecord::Migration[8.0]
  def change
    add_column :transactions, :company_id, :string
    add_column :transactions, :workspace_id, :string
    add_column :transactions, :application_id, :string
    add_column :transactions, :correlation_id, :string
  end
end
