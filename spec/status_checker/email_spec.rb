require 'spec_helper'

RSpec.describe StatusChecker::Email do

  subject do
    StatusChecker::Email.new(["technical_root@mail.ru"])
  end

  it "raises ArgumentError if array with receivers is empty" do
    expect{StatusChecker::Email.new([])}.to raise_error(ArgumentError)
  end

  it "creates Net::SMTP object" do
    expect(subject.instance_variable_get('@smtp').class).to be(Net::SMTP)
  end

  context "when call send method" do

    it "starts smtp and get response started=true" do
      allow(subject.instance_variable_get('@smtp')).to receive(:start).
        and_call_original
      expect(subject.instance_variable_get('@smtp')).to receive(:started?).
        and_return(true)
      subject.send(url, fake_response)
    end

    it "calls send_message" do
      expect(subject.instance_variable_get('@smtp')).to receive(:send_message)
      subject.send(url, fake_response)
    end

    it "calls finish method and get status 221" do
      expect(subject.instance_variable_get('@smtp')).to receive(:finish).
        and_return(221)
      subject.send(url, fake_response)
    end
  end
end
