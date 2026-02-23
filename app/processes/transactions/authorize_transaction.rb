# frozen_string_literal: true

module Transactions
  class AuthorizeTransaction < Solid::Process

    dependencies do
      attribute :send_callback_job
    end

    input do
      attribute :transaction_id

      validates :transaction_id, presence: true
    end

    def call(attributes)
      transaction = dependencies.transaction_repository.find(attributes[:transaction_id])

      raise ActiveRecord::RecordNotFound if transaction.nil?

      do_authorize(transaction:)

      dependencies.send_callback_job.perform_later(transaction_id: transaction.id, error: {})

      Success(:transaction_authorized)
    rescue StandardError => e
      error = { code: "operation_failed", message: e.message }

      Failure(:authorize_failed, errors: [ error ])
    end

    private

    def do_authorize(transaction:)
      transaction.authorize!
    end
  end
end
