require 'spec_helper'

RSpec.describe StatusChecker::Check do

  def fake_response
    net_http_resp = Net::HTTPResponse.new(1.0, 301, "Moved Permanently")
  end

  def url
    "http://example.com"
  end

  it "starts timer when we start to check" do
    expect(subject.instance_variable_get '@timer').to receive(:start)
    subject.start
  end

  context "when status code not 200 and it's not recurrent code" do

    before do
      allow(subject).to receive(:recurrent_code?).and_return(false)
      allow(subject).to receive(:check_http_status_of).and_return(fake_response)
    end

    it "calls email send" do
      expect(subject).to receive(:send_email)
      subject.check_url(url)
    end

    it "adds status code to stack of the responses" do
      expect(subject).to receive(:add_code_to_resp_stack)
      subject.check_url(url)
    end
  end

  it "stops timer when we stop to check" do
    expect(subject.instance_variable_get '@timer').to receive(:stop)
    subject.stop
  end
end
