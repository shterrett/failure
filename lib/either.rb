require_relative "./shared"

module Either
  def self.new(&block)
    val = begin
            block.call()
          rescue Exception => e
            e
          end
    if val.nil? || val.is_a?(Exception)
      Left.new(val)
    else
      Right.new(val)
    end
  end

  def self.match(e, left:, right:)
    if e.right?
      right.call(e.send(:val))
    elsif e.left?
      left.call(e.send(:val))
    end
  end

  class Left
    include Shared

    def left?
      true
    end
    def right?
      false
    end

    def initialize(val)
      @val = val
    end

    def map(&block)
      self
    end

    def flat_map(&block)
      self
    end

    private
    attr_reader :val
  end

  class Right
    include Shared

    def left?
      false
    end
    def right?
      true
    end

    def initialize(val)
      @val = val
    end

    def map
      Either.new { yield val }
    end

    def flat_map
      yield val
    end

    private
    attr_reader :val
  end
end
