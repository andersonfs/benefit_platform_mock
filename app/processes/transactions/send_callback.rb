# frozen_string_literal: true

module Transactions
  class SendCallback < Solid::Process
    dependencies do
      attribute :transaction_repository
      attribute :callback_gateway
    end

    input do
      attribute :transaction_id
      attribute :error

      validates :transaction_id, presence: true
    end

    def call(attributes)
      transaction = dependencies.transaction_repository.find(attributes[:transaction_id])

      raise ActiveRecord::RecordNotFound if transaction.nil?

      response = dependencies.callback_gateway.request(params: build_params(transaction:, error: attributes[:error]))
      if response.success
        Success(:callback_sent)
      else
        Failure(:callback_error, errors: [ response[:data] ])
      end
    end

    private

    def build_params(transaction:, error:)
      {
        recipient: transaction.recipient,
        amount: transaction.amount,
        external_id: transaction.external_id,
        status: transaction.status,
        error: {
          code: error[:code],
          message: error[:message]
        }
      }.compact!
    end

  end
end
