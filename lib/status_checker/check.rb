require "net/https"
require "uri"

module StatusChecker
  class Check
    def initialize(email="andgursky@gmail.com", per=60,
                   domain=["https://pokupon.ua", "https://partner.pokupon.ua"])
      # initialize all instanse variables
      @email    = email
      @period   = per
      @domain   = domain
    end

    def start
      # run checker loop
      @domain.each do |url|
        http_status = check_http_status_of(url)
        email.send(http_status) unless http_status.code == 200
      end
    end

    def stop
      # stop checker loop
    end

    private

    def check_http_status_of(url)
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == "https"
      request = Net::HTTP::Get.new(uri.request_uri)
      http.request(request)
    end
  end
end
