require "spec_helper"

describe Maybe do
  describe "new" do
    it "returns a Just when given a non-nil value" do
      m = Maybe.new do
        5
      end

      expect(m.is_just?).to be_truthy
      expect(m.is_nothing?).to be_falsey
      expect(m).to be_an_instance_of Maybe::Just
    end

    it "returns a Nothing when given a nil value"do
      m = Maybe.new do
        nil
      end

      expect(m.is_just?).to be_falsey
      expect(m.is_nothing?).to be_truthy
      expect(m).to be_an_instance_of Maybe::Nothing
    end

    it "returns a Nothing if the expression throws an exception" do
      m = Maybe.new do
        1 / 0
      end

      expect(m.is_just?).to be_falsey
      expect(m.is_nothing?).to be_truthy
      expect(m).to be_an_instance_of Maybe::Nothing
    end
  end

  describe "==" do
    it "is false if one side is Just and the other is Nothing" do
      j = Maybe.new { 5 }
      n = Maybe.new { nil }
      fake = Maybe::Just.new(nil)

      expect(j == n).to be_falsey
      expect(n == j).to be_falsey
      expect(j == fake).to be_falsey
    end

    it "delegates to the value when comparing Just values" do
      j_1 = Maybe.new { 5 }
      j_2 = Maybe.new { 6 }
      j_3 = Maybe.new { 5 }

      expect(j_1).not_to eq j_2
      expect(j_1).to eq j_3
    end
  end

  describe "match" do
    it "runs the function given for Just and returns the result if the variant is Just" do
      m = Maybe::Just.new(5)
      result = Maybe.match(
        m,
        just: ->(v) { v + 5 },
        nothing: -> { 0 }
      )

      expect(result).to eq 10
    end

    it "runs the function given for Nothing and returns the result if the variant is Nothing" do
      m = Maybe::Nothing.new
      result = Maybe.match(
        m,
        just: ->(v) { v + 5 },
        nothing: -> { 0 }
      )

      expect(result).to eq 0
    end

    it "returns the static default given for Nothing if the variant is Nothing" do
      m = Maybe::Nothing.new
      result = Maybe.match(
        m,
        just: ->(v) { v + 5 },
        nothing: 0
      )

      expect(result).to eq 0
    end
  end
end

describe Maybe::Nothing do
  describe "map" do
    it "returns itself, ignoring the function" do
      n = Maybe::Nothing.new.map do |v|
        v * 5
      end

      expect(n).to eq Maybe::Nothing.new
    end
  end

  describe "flat_map" do
    it "returns itself, ignoring the function" do
      n = Maybe::Nothing.new.flat_map do |v|
        Maybe.new { v * 5 }
      end

      expect(n).to eq Maybe::Nothing.new
    end
  end
end

describe Maybe::Just do
  describe "map" do
    it "applies the function to the wrapped value and returns the wrapped result" do
      j = Maybe::Just.new(5).map do |v|
        v * 5
      end

      expect(j).to eq Maybe::Just.new(25)
    end
  end

  describe "flat_map" do
    it "applies the function to the wrapped value and returns the resulting Maybe" do
      m = Maybe::Just.new(5).flat_map do |v|
        Maybe.new { v / 0 }
      end

      expect(m.is_nothing?).to be_truthy
    end
  end
end
