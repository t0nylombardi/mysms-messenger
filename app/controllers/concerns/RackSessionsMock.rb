# frozen_string_literal: true

module RackSessionsMock
  extend ActiveSupport::Concern

  class MockRackSession < Hash
    def enabled?
      false
    end

    def destroy
    end
  end

  included do
    before_action :set_mock_session

    private

    def set_mock_session
      request.env["rack.session"] ||= MockRackSession.new
    end
  end
end
