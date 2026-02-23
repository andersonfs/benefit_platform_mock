# frozen_string_literal: true

module Sdk
  module Api
    class HttpErrorMiddleware < Faraday::Middleware
      def call(env)
        @app.call(env).on_complete { |response| handle_error(response) }
      rescue Sdk::Api::Error::HttpError => e
        log_error(e)
        raise
      end

      private

      def handle_error(response) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/MethodLength
        return if success_status?(response.status)

        case response.status
        when 400
          raise Sdk::Api::Error::BadRequestError, response
        when 401
          raise Sdk::Api::Error::UnauthorizedError, response
        when 403
          raise Sdk::Api::Error::ForbiddenError, response
        when 404
          raise Sdk::Api::Error::NotFoundError, response
        when 422
          raise Sdk::Api::Error::UnprocessableEntityError, response
        when 500
          raise Sdk::Api::Error::InternalServerError, response
        when 502
          raise Sdk::Api::Error::BadGatewayError, response
        when 503
          raise Sdk::Api::Error::ServiceUnavailableError, response
        when 504
          raise Sdk::Api::Error::GatewayTimeoutError, response
        else
          raise Sdk::Api::Error::UnmappedHttpError, response
        end
      end

      def success_status?(status) = (200..299).cover?(status)

      def log_error(error)
        Sdk::Api::Config.logger.error(
          message: "HTTP REQUEST (FAILED): #{error.try(:request)}",
          error: {
            type: error.class.to_s,
            message: error.message || "unknown error"
          }
        )
      end
    end
  end
end

