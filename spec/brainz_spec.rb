require_relative '../spec/spec_helper'

describe Brainz::Brainz do
  subject { Brainz::Brainz.new }

  describe "#that" do
    it "should return itself" do
      subject.that.should == subject
    end

    it "should reset teaching if no args" do
      subject.teaching = {speed: 5}
      subject.that.teaching.should be_nil
    end

    it "should change teaching hash" do
      expect {
        subject.that(speed: 15)
      }.to change { subject.teaching }.to({speed: 15})
    end

    it "should add value to teaching hash" do
      expect {
        subject.that speed: 100, time: 0.25
      }.to change { subject.teaching }.from(nil).to({speed: 100, time: 0.25})
    end

    it "should add unnamed value to teaching" do
      expect {
        subject.that 100, 0.25
      }.to change { subject.teaching }.from(nil).to([100, 0.25])
    end
  end

  describe "#is" do
    before do
      subject.stubs(:update)
      subject.stubs(:back_propagate)
    end

    it "should return true" do
      subject.teaching = {a: 1, b: 1}
      subject.is(sum: 2).should be_true
    end

    it "should return false if there was no example" do
      subject.teaching = nil
      subject.is(sum: 2).should be_false
    end
  end

  describe "#teach" do
    it "should fill input layer" do
      subject.teach do
        subject.that(a: 6, b: 7).is(13)
      end
      subject.input_act.length.should == 3 # + 1 input bias
    end

    it "should fill in correct order" do
      subject.teach do
        subject.that(a: 6, b: 7).is(13)
      end
      subject.input_act.should == [6, 7, 0] # 0 - input bias
    end

    it "should not change order" do
      subject.teach do
        subject.that(a: 6, b: 7).is(13)
        subject.that(b: 8, a: 9).is(17)
      end
      subject.input_act.should == [9, 8, 0] # 0 - input bias
    end

    it "should write to input directly" do
      subject.teach do
        subject.that(speed: 100, time: 0.5).is(50)
        subject.that(50, 1).is(50)
      end
      subject.input_act.should == [50, 1, 0] # 0 - input bias
    end

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
    it "should return 7" do
      subject.stubs(num_input: 5, num_output: 6)
      subject.num_hidden.should == 7
    end
  end

  describe "#explain" do
    it "should return output_activation" do
      subject.teach(max_iterations: 100) do
        subject.that(1, 1).is(1)
      end
      subject.stubs(ouptut_act: [1])
      subject.explain(1, 1).should == 1
    end
  end

  describe "#update" do
    before do
      subject.stubs(num_hidden: 2)
    end

    it "should return subject" do
      subject.update([], []).should == subject
    end

    it "should create weight matrices" do
      Kernel.stubs(rand: 0)
      expect {
        expect {
          subject.update([1.0, 1.0], [1.0])
        }.to change { subject.input_weights }.from(nil).to([[-0.2, -0.2], [-0.2, -0.2], [-0.2, -0.2]])
      }.to change { subject.output_weights }.from(nil).to([[-2], [-2]])
    end

    it "should create input weights matrix size of input and hidden" do
      matrix = subject.update([0, 1, 0], [0]).input_weights
      matrix.size.should == 4
      matrix[0].size.should == 2
    end

    it "should create output weights matrix size of hidden and output" do
      matrix = subject.update([0, 1, 0], [0]).output_weights
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

      subject.explain(a: 0, b: 0).should == 0
      subject.explain(a: 0, b: 1).should == 1
      subject.explain(a: 1, b: 1).should == 0
      subject.explain(a: 1, b: 0).should == 1
    end
  end
end
