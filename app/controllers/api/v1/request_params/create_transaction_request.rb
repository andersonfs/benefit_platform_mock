# frozen_string_literal: true

module Api
  module V1
    module RequestParams
      class CreateTransactionRequest

        def initialize(params, headers)
          self.params = params
          self.headers = headers
        end

        def build_params
          {
            product_id: params["product_id"],
            recipient: params["recipient"],
            amount: params["amount"],
            unit: params["unit"],
            external_id: params["external_id"],
            customer_id: params["customer_id"],
            authorization_callback_url: params["authorization_callback_url"],
            correlation_id: headers["x-correlation-id"],
            company_id: headers["x-company-id"],
            workspace_id: headers["x-workspace-id"],
            application_id: headers["x-application-id"],
            status: "created"
          }.deep_symbolize_keys
        end

        private

        attr_accessor :params, :headers
      end
    end
  end
end

