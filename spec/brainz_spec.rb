require_relative '../spec/spec_helper'

describe Brainz::Brainz do
  subject { Brainz::Brainz.new }

  describe "#that" do
    it "should return itself" do
      subject.that.should == subject
    end

    it "should reset input if no args" do
      subject.input = {speed: 5}
      subject.that.input.should be_nil
    end

    it "should change input order" do
      expect {
        subject.that(speed: 15)
      }.to change { subject.input_order }.from(nil).to([:speed])
    end

    it "should add value to input hash" do
      expect {
        subject.that speed: 100, time: 0.25
      }.to change { subject.input }.from(nil).to([100, 0.25])
    end

    it "should add unnamed value to input" do
      expect {
        subject.that 100, 0.25
      }.to change { subject.input }.from(nil).to([100, 0.25])
    end
  end

  describe "#teach" do
    it "should return iteration and error" do
      Kernel.stubs(random: 0)
      last_iteration = last_error = 0
      subject.teach(max_iterations: 2) do |iteration, error|
        subject.that(1, 1).is(1)
        last_iteration, last_error = iteration, error
      end

      last_iteration.should == 1
      last_error.should be_within(1).of(1)
    end
  end

  describe "#num_hidden" do
    it "should return [7]" do
      subject.stubs(num_input: 5, num_output: 6)
      subject.num_hidden.should == [7]
    end
  end

  describe "#explain" do
    it "should return output_activation" do
      subject.stubs(output_act: [1], update: nil)
      subject.explain(1, 1).should == [1]
    end
  end

  describe "#guess" do
    it "should return return rounded value if only one output" do
      subject.stubs(num_output: 1)
      subject.stubs(output_act: [0.5], update: nil)
      subject.guess(1).should == 1
    end

    it "should return best matching key if more than one output" do
      subject.stubs(output_act: [0.5, 0.7], update: nil, output_order: [:green, :yellow])
      subject.guess([]).should == :yellow
    end

    it "should return b" do
      subject.stubs(num_output: 2)
      subject.stubs(output_act: [0.5, 0.7], update: nil)
      subject.guess([]).should == :b
    end
  end


  describe "#update" do

    before do
      pending
      subject.stubs(num_hidden: 2, num_output: 1)
    end

    it "should return subject" do
      subject.update([]).should == subject
    end

    it "should create weight matrices" do
      Kernel.stubs(rand: 0)
      expect {
        expect {
          subject.update([1.0, 1.0])
        }.to change { subject.input_weights }.from(nil).to([[-0.2, -0.2], [-0.2, -0.2], [-0.2, -0.2]])
      }.to change { subject.output_weights }.from(nil).to([[-2], [-2]])
    end

    it "should create input weights matrix size of input and hidden" do
      matrix = subject.update([0, 1, 0]).input_weights
      matrix.size.should == 4
      matrix[0].size.should == 2
    end

    it "should create output weights matrix size of hidden and output" do
      matrix = subject.update([0, 1, 0]).output_weights
      matrix.size.should == 2
      matrix[0].size.should == 1
    end
  end

  describe "xor" do
    it "should learn xor" do
      subject.teach do
        subject.that(a: 1, b: 1).is(0)
        subject.that(1, 0).is(1)
        subject.that(0, 1).is(1)
        subject.that(0, 0).is(0)
      end

      subject.explain(a: 0, b: 0).first.round.should == 0
      subject.explain(a: 0, b: 1).first.round.should == 1
      subject.explain(a: 1, b: 1).first.round.should == 0
      subject.explain(a: 1, b: 0).first.round.should == 1
    end
  end
end
