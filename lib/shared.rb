module Shared
  def ==(other)
    self.class == other.class &&
      other.val_eq?(val)
  end

  def val_eq?(other_val)
    other_val == val
  end
end
