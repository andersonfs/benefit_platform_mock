# frozen_string_literal: true

module Sdk
  module Api
    module Config
      class << self

        def logger = Rails.logger

        def cache = Rails.cache

      end
    end
  end
end
