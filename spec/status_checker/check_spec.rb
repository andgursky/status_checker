require 'spec_helper'
require 'pry'

RSpec.describe StatusChecker::Check do

  def fake_response
    net_http_resp = Net::HTTPResponse.new(1.0, 301, "Moved Permanently")
  end

  it "starts timer when we start to check" do
    expect(subject.instance_variable_get '@timer').to receive(:start)
    subject.start
  end

  context "when status code not 200 and it's not recurrent code" do

    let(:email) { StatusChecker::Email.new(["fake@email.com"]) }

    before do
      allow(subject).to receive(:recurrent_code?).and_return(false)
    end

    it "calls email send" do
      expect(email).to receive(:send)
      subject.check_response_code(fake_response, subject.send(:recurrent_code?))
    end

    it "adds status code to stack of the responses" do
      expect(subject).to receive(:add_code_to_resp_stack)
      subject.check_response_code(fake_response, subject.send(:recurrent_code?))
    end
  end

  it "stops timer when we stop to check" do
    expect(subject.instance_variable_get '@timer').to receive(:stop)
    subject.stop
  end
end
