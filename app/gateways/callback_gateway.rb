# frozen_string_literal: true

class CallbackGateway < ApplicationGateway
  def initialize(params:)
    self.params = params
    self.connection = Sdk::Api::Connection.new(url: params[:authorization_callback_url])
  end

  def request
    response = connection.post(body: build_body, headers: build_headers)

    success(data: { status: response.status })
  rescue Sdk::Api::Error::HttpError => e
    failure(data: { status: e.status, body: e.body })
  end

  private

  attr_accessor :params

  def build_body
    {
      recipient: params[:recipient],
      amount: params[:amount],
      external_id: params[:external_id],
      status: params[:status],
      error: {
        code: params[:error][:code],
        message: params[:error][:message]
      }.compact
    }
  end

  def build_headers
    {
      "x-correlation-id" => params[:correlation_id],
      "x-company" => params[:company_id],
      "x-workspace" => params[:workspace_id],
      "x-application" => params[:application_id]
    }
  end
end
