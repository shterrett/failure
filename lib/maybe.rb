require_relative "./shared"

module Maybe
  def self.new(&block)
    val = begin
            block.call()
          rescue Exception => e
            e
          end
    if val.nil? || val.is_a?(Exception)
      Nothing.new
    else
      Just.new val
    end
  end

  def self.match(m, just:, nothing:)
    if m.is_just?
      just.call(m.send(:val))
    elsif m.is_nothing?
      if nothing.is_a? Proc
        nothing.call
      else
        nothing
      end
    end
  end

  class Just
    include Shared

    def is_just?
      true
    end
    def is_nothing?
      false
    end

    def initialize(val)
      @val = val
    end

    def map
      Maybe.new { yield val }
    end

    def flat_map
      yield val
    end

    private
    attr_reader :val
  end

  class Nothing
    include Shared

    def is_just?
      false
    end
    def is_nothing?
      true
    end

    def map(&block)
      self
    end

    def flat_map(&block)
      self
    end

    private

    def val
      nil
    end
  end
end
