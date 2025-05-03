# frozen_string_literal: true

module Api
  module V1
    class MessagesController < ApplicationController
      before_action :authenticate_user!

      def create
        result = Twilio::SmsMessageService.call(
          to: params[:to],
          body: params[:body],
          user: current_user
        )

        if result.success?
          render json: MessageSerializer.render(result.data), status: :ok
        else
          render json: {error: result.error}, status: :unprocessable_entity
        end
      end

      def index
        messages = current_user.messages.order(created_at: :desc).to_a
        render json: MessageSerializer.render(messages, view: :default, root: :messages), status: :ok
      end

      private

      def message_params
        params.permit(:to, :body)
      end
    end
  end
end
