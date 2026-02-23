class Transaction < ApplicationRecord
  Data = ::Data.define(
    :id,
    :correlation_id,
    :external_id,
    :status,
    :company_id,
    :workspace_id,
    :application_id,
    :customer_id,
    :product_id,
    :recipient,
    :unit,
    :amount,
    :authorization_callback_url,
    :created_at,
    :updated_at
  )

  validates :status, :company_id, :application_id, :customer_id, :product_id, :recipient, :unit, :external_id, :amount, :authorization_callback_url, presence: true
  validates :correlation_id, presence: true, uniqueness: true

  include AASM

  aasm(column: :status) do
    state :created, :failed, :authorized, :confirmed, :canceled

    event :authorize do
      transitions from: :created, to: :authorized
    end

    event :confirm do
      transitions from: :authorize, to: :confirmed
    end

    event :cancel do
      transitions from: :authorize, to: :canceled
    end

    event :fail do
      transitions from: %i[authorized confirmed], to: :failed
    end
  end

  def build_data(includes: [])
    Data.new(
      id:,
      correlation_id:,
      external_id:,
      status:,
      company_id:,
      workspace_id:,
      application_id:,
      customer_id:,
      product_id:,
      recipient:,
      unit:,
      amount:,
      authorization_callback_url:,
      created_at:,
      updated_at:
    )
  end
end
