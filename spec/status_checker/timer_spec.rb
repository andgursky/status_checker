require 'spec_helper'

RSpec.describe StatusChecker::Timer do

  subject do
    StatusChecker::Timer.new(10)
  end

  it "raises an ArgumentError when interval less then zero" do
    expect{StatusChecker::Timer.new(-1)}.to raise_error(ArgumentError)
  end

  it "set instance variable @run to false when method stop called" do
    allow(subject).to receive(:synchronize).and_yield
    subject.instance_variable_set('@th', Thread.new{})
    subject.stop
    expect(subject.instance_variable_get '@run').to be false
  end
end
