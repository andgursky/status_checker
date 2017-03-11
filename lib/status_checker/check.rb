require "status_checker/timer"
require "net/https"
require "uri"

module StatusChecker
  class Check
    def initialize(email="andgursky@gmail.com", per=10,
                   domain=["https://pokupon.ua", "https://partner.pokupon.ua"])
      # initialize all instanse variables
      @email    = email
      @delay    = per
      @domain   = domain
      @timer    = StatusChecker::Timer.new(@delay)
    end

    def start
      # run checker loop
      threads = []
      @timer.start do
        @domain.each do |dom|
          threads << Thread.new(dom) do |url|
            response = check_http_status_of(url)
            email.send(response) unless response.code == 200
          end
        end
        threads.each { |thr| thr.join }
      end
    end

    def stop
      # stop checker loop
      @timer.stop
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
