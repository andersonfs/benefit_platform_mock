# frozen_string_literal: true

module Sdk
  module Api
    class Connection
      def initialize(url:)
        @connection = Faraday.new(url:) do |conn|
          conn.response :logger, nil, formatter: Sdk::Api::LogFormatter
          conn.response :json
          conn.request :json
          conn.use(Sdk::Api::HttpErrorMiddleware)
          conn.adapter(Faraday.default_adapter)
          conn
        end
      end

      def post(*) = @connection.post(*)

      def get(*) = @connection.get(*)

      def put(*) = @connection.put(*)

      def delete(*) = @connection.delete(*)

      def patch(*) = @connection.patch(*)

    end
  end
end

