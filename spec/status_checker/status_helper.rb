
  def fake_response
    net_http_resp = Net::HTTPResponse.new(1.0, 301, "Moved Permanently")
  end

  def url
    "http://example.com"
  end

