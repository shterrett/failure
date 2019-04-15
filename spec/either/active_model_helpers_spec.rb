require "spec_helper"

describe Either::ActiveModelHelpers do
  class MockActiveModelErrors
    def to_h
      {}
    end

    def present?
      !to_h.empty?
    end
  end

  class MockActiveModelObject < OpenStruct
    include Either::ActiveModelHelpers

    def self.create(options)
      new(options)
    end

    def errors
      MockActiveModelErrors.new
    end
  end

  describe "#to_either" do
    it "wraps an object with no errors in Either::Right" do
      object = MockActiveModelObject.create(a: :allosaurus, b: :brachiosaurus)
      either = object.to_either

      expect(either).to be_right
      expect(either.send(:val)).to eq(object)
    end

    it "converts an object with errors into an errors object wrapped in Either::Left" do
      object = MockActiveModelObject.create(c: :chrysanthemum, d: :dolomite_lime)

      mock_errors = MockActiveModelErrors.new
      allow(MockActiveModelErrors).to receive(:new).and_return(mock_errors)
      allow(mock_errors).to receive(:to_h).and_return({ base: ["only accepts dinosaurs"] })

      either = object.to_either

      expect(either).to be_left
      expect(either.send(:val)).to eq mock_errors
      expect(either.send(:val).to_h).to eq(
        { base: ["only accepts dinosaurs"] }
      )
    end
  end
end
