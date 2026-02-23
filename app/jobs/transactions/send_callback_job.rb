# frozen_string_literal: true

module Transactions
  class SendCallbackJob < ApplicationJob
    queue_as :callbacks

    def perform(params)
      dependencies = {
        transaction_repository: Transaction,
        callback_gateway: CallbackGateway
      }
      ::Transactions::SendCallback.new(dependencies).call(params)
    end
  end
end
