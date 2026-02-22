module Api
  module V1
    class TransactionsController < ApplicationController

      def create
        transaction_request_params = build_transaction_request_params

        response = create_transaction(transaction_request_params)

        render_process_response(response)
      end

      private

      def build_transaction_request_params
        RequestParams::CreateTransactionRequest.new(transaction_params, request.headers).build_params
      end

      def transaction_params
        params.permit(
          :product_id, :recipient, :amount,
                  :unit, :external_id, :customer_id, :authorization_callback_url
        )
      end

      def create_transaction(transaction_request_params)
        dependencies = {
          transaction_repository: Transaction
        }
        ::Transactions::CreateTransaction.new(dependencies).call(transaction_request_params)
      end

      def render_process_response(response)
        case response
        in Solid::Output::Success
          render json: response[:transaction], status: :created
        in Solid::Output::Failure(type: :transaction_already_exists, value: { errors: })
          render json: { errors: }, status: :not_found
        in Solid::Output::Failure(type: _, value: { errors: })
          render json: { errors: }, status: :unprocessable_entity
        end
      end
    end
  end
end

