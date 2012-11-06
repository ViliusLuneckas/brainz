require 'spec_helper'
require 'fileutils'

describe "loader" do
  let(:file_path) { File.expand_path('spec/fixtures/brainz.b') }

  subject { Brainz::Brainz.new }

  before do
    subject.teach do
      subject.that(a: 1, b: 1).is(0)
      subject.that(1, 0).is(1)
      subject.that(0, 1).is(1)
      subject.that(0, 0).is(0)
    end
  end

  it "should work after load" do
    results_before_saving = []
    results_before_saving << subject.explain(a: 0, b: 0).first.round
    results_before_saving << subject.explain(a: 0, b: 1).first.round
    results_before_saving << subject.explain(a: 1, b: 1).first.round
    results_before_saving << subject.explain(a: 1, b: 0).first.round

    subject.save(file_path)
    loaded_brainz = Brainz::Brainz.load(file_path)

    results_after_load = []
    results_after_load << subject.explain(a: 0, b: 0).first.round
    results_after_load << subject.explain(a: 0, b: 1).first.round
    results_after_load << subject.explain(a: 1, b: 1).first.round
    results_after_load << subject.explain(a: 1, b: 0).first.round

    results_before_saving.should == results_after_load
  end
end
