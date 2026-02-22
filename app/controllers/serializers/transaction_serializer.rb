# frozen_string_literal: true

class TransactionSerializer < ActiveModel::Serializer
  attributes :external_id, :recipient, :status, :company_id, :workspace_id,
             :application_id, :correlation_id, :amount,
             :customer_id, :product_id, :unit

end
