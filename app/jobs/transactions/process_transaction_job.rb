# frozen_string_literal: true

class ProcessTransactionJob < ApplicationJob
  queue_as :transactions

  def perform(params)
    transaction_id = params[:transaction_id]
    dependencies = {
      send_callback_job: ::Transactions::SendCallbackJob
    }
    ::Transactions::AuthorizeTransaction.new(dependencies).call(params)
  end
end
