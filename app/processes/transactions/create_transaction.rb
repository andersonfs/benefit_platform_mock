# frozen_string_literal: true

module Transactions
  class CreateTransaction < Solid::Process

    dependencies do
      attribute :transaction_repository
    end

    input do
      attribute :correlation_id
      attribute :company_id
      attribute :workspace_id
      attribute :application_id
      attribute :amount
      attribute :customer_id
      attribute :product_id
      attribute :unit
      attribute :external_id
      attribute :recipient
      attribute :authorization_callback_url

      validates :correlation_id, :external_id, :company_id, :workspace_id, :application_id, :customer_id, :product_id, :authorization_callback_url, presence: true

      validate do
        errors.add(:amount, " can\'t be less than zero") if amount <= 0
        errors.add(:unit, " can\'t be blank") if unit.blank?
      end
    end

    def call(attributes)
      return transaction_already_exists_failure if transaction_already_exists?(attributes[:external_id])

      transaction = dependencies.transaction_repository.create!(attributes.merge(status: "created"))

      Success(:transaction_created, transaction:)
    end

    private

    def transaction_already_exists?(external_id) = dependencies.transaction_repository.exists?(external_id:)

    def transaction_already_exists_failure = Failure(:transaction_already_exists, errors: ["Transaction already exists"])
  end
end
