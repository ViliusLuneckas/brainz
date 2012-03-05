require_relative '../spec/spec_helper'

describe Array do
  describe "#to_hash" do
    it "should return new hash" do
      [1, 2, 3].to_hash([:a, :b, :c]).should == {a: 1, b: 2, c: 3}
    end
  end
end