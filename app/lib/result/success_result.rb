# frozen_string_literal: true

module Result
  class SuccessResult
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def success?
      true
    end
  end
end
