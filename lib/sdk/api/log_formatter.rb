# frozen_string_literal: true

module Sdk
  module Api
    class LogFormatter < Faraday::Logging::Formatter

      def request(env) = log_info(__method__, env)

      def response(env) = log_info(__method__, env)

      private

      def log_info(method, env)
        Sdk::Api::Config.logger.info(
          message: "HTTP #{method.upcase} (#{env.method.to_s.upcase}): #{env.url} #{env.status}".strip,
          http: build_http(env),
          hierarchy: build_hierarchy(env)
        )
      end

      def build_http(env)
        {
          request: {
            id: request_id(env),
            body: { content: parse_body(env.request_body) }
          },
          response: {
            status_code: env.status,
            body: { content: parse_body(env.response_body) }
          }
        }
      end

      def request_id(env)
        return if env.request_headers.blank?

        env.request_headers['x-correlation-id'] || env.request_headers['X-Correlation-Id'] || env.request_headers['correlation-id']
      end

      def parse_body(body)
        return body if body.is_a?(String)

        body.to_json
      end

      def build_hierarchy(env)
        {
          company_id: company_id(env.request_headers),
          workspace_id: workspace_id(env.request_headers),
          application_id: application_id(env.request_headers)
        }.compact
      end

      def company_id(headers)
        return if headers.blank?

        headers['X-Company-Id'] || headers['x-company-id'] || headers['Company-Id'] || headers['company-id'] ||
          headers['x-company'] || headers['X-Company']
      end

      def workspace_id(headers)
        return if headers.blank?

        headers['X-Workspace-Id'] || headers['x-workspace-id'] || headers['Workspace-Id'] || headers['workspace-id'] ||
          headers['x-workspace'] || headers['X-Workspace']
      end
    end
  end
end
