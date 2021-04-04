# frozen_string_literal: true

module Api
  module V1
    class BaseController < ActionController::API
      include Api::ExceptionHandler
      include ActionController::HttpAuthentication::Token::ControllerMethods

      before_action :authenticate

      def authenticate
        authenticate_or_request_with_http_token do |token, _options|
          # 認証処理 および レスポンスが必要な場合は記述
          @_current_user ||= ApiKey.find_by(access_token: token)&.user
        end
      end

      def current_user
        @_current_user
      end
    end
  end
end
