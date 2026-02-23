# frozen_string_literal: true

module Sdk
  module Api
    module Error
      class HttpError < StandardError
        attr_reader :status, :request, :request_body, :body, :request_headers, :headers

        def initialize(response)
          @status = response.status
          @request = "#{response.method.to_s.upcase} #{response.url}"
          @headers = response.response_headers
          @request_headers = response.request_headers
          @body = JSON.parse(response.response_body) rescue nil # rubocop:disable Style/RescueModifier
          @request_body = JSON.parse(response.request_body) rescue nil # rubocop:disable Style/RescueModifier

          super({ request_body:, body:, request_headers:, headers:, request:, status: }.compact.to_json)
        end
      end
    end
  end
end
