# frozen_string_literal: true

class ApplicationGateway
  Response = Data.define(:success, :data, :errors)

  def self.request(**args) = new(**args).request

  def request = raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"

  private_class_method :new

  private

  attr_accessor :connection

  def success(data:)
    Response.new(success: true, data:, errors: nil)
  end

  def failure(data: nil, errors: nil)
    Response.new(success: false, data:, errors:)
  end
end
