require "spec_helper"

describe Either do
  describe "new" do
    it "returns a Right when given a non-nil value" do
      e = Either.new do
        5
      end

      expect(e.left?).to be_falsey
      expect(e.right?).to be_truthy
      expect(e).to be_an_instance_of Either::Right
    end

    it "returns a Left when given a nil value" do
      e = Either.new do
        nil
      end

      expect(e.left?).to be_truthy
      expect(e.right?).to be_falsey
      expect(e).to be_an_instance_of Either::Left
    end

    it "returns a Left wrapping a returned exception" do
      e = Either.new do
        1 / 0
      end

      expect(e.left?).to be_truthy
      expect(e.right?).to be_falsey
      expect(e).to be_an_instance_of Either::Left
    end
  end

  describe "==" do
    it "is false if one side is Left and the other is Right" do
      r = Either.new { 5 }
      l = Either.new { nil }
      fake = Either::Right.new(nil)

      expect(r == l).to be_falsey
      expect(l == r).to be_falsey
      expect(r == fake).to be_falsey
    end

    it "delegates to the value equality when comparing the same variant" do
      r_1 = Either.new { 5 }
      r_2 = Either.new { 6 }
      r_3 = Either.new { 5 }

      expect(r_1).not_to eq r_2
      expect(r_1).to eq r_3

      l_1 = Either.new { nil }
      l_2 = Either.new { 1 / 0 }
      l_3 = Either.new { nil }

      expect(l_1).not_to eq l_2
      expect(l_1).to eq l_3
    end
  end

  describe "match" do
    it "runs the function given for Right and returns the result if the variant is a Right" do
      e = Either::Right.new(5)
      result = Either.match(
        e,
        left: ->(v){ v + 5 },
        right: ->(v){ v * 5 }
      )

      expect(result).to eq 25
    end

    it "runs the function given for Left and returns the result if the variant is a Left" do
      e = Either::Left.new(5)
      result = Either.match(
        e,
        left: ->(v){ v + 5 },
        right: ->(v){ v * 5 }
      )

      expect(result).to eq 10
    end
  end
end

describe Either::Left do
  describe "map" do
    it "returns itself, ignoring the function" do
      l = Either::Left.new(nil).map do |v|
        v * 5
      end

      expect(l).to eq Either::Left.new(nil)
    end
  end

  describe "flat_map" do
    it "returns itself, ignoring the function" do
      l = Either::Left.new(nil).map do |v|
        Either.new { v / 0 }
      end

      expect(l).to eq Either::Left.new(nil)
    end
  end
end

describe Either::Right do
  describe "map" do
    it "applies the function to the wrapped value and returns the wrapped result" do
      r = Either::Right.new(5).map do |v|
        v + 5
      end

      expect(r).to eq Either::Right.new(10)
    end
  end

  describe "flat_map" do
    it "applies the function to the wrapped value and returns the resulting Either" do
      r = Either::Right.new(5).flat_map do |v|
        Either.new { v / 0 }
      end

      expect(r.left?).to be_truthy
    end
  end
end
