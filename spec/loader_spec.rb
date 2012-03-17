require_relative '../spec/spec_helper'
require 'fileutils'

describe "loader" do
  describe "xor" do
    subject { Brainz::Brainz.new }

    it "should work after load" do
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

      subject.save(File.expand_path('.', 'temp/brainz.b'))


      old_brainz = Brainz::Brainz.load(File.expand_path('.', 'temp/brainz.b'))
      old_brainz.explain(a: 0, b: 0).first.round.should == 0
      old_brainz.explain(a: 0, b: 1).first.round.should == 1
      old_brainz.explain(a: 1, b: 1).first.round.should == 0
      old_brainz.explain(a: 1, b: 0).first.round.should == 1
    end
  end
end
