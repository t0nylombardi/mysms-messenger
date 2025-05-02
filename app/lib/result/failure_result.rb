# frozen_string_literal: true

module Result
  class FailureResult
    attr_reader :error

    def initialize(error)
      @error = error
    end

    def success?
      false
    end
  end
end
