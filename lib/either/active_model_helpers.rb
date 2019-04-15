require_relative "../either"

module Either
  module ActiveModelHelpers
    def to_either
      if self.errors.present?
        Either::Left.new(self.errors)
      else
        Either::Right.new(self)
      end
    end
  end
end
