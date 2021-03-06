require "status_checker/timer"
require "status_checker/email"
require "net/https"
require "uri"

module StatusChecker
  class Check

    def initialize(email=["technical_root@mail.ru"], per=10,
                   domain=["https://ukr.net", "https://yandex.ru"])
      # initialize all instanse variables
      extend MonitorMixin
      @email    = email
      @delay    = per
      @domain   = domain
      @timer    = StatusChecker::Timer.new(@delay)
      @resp_stack = Hash.new
    end

    def start
      # run checker loop
      threads = []
      @timer.start do
        @domain.each do |dom|
          threads << Thread.new(dom) do |url|
            check_url(url)
          end
        end
        threads.each { |thr| thr.join }
      end
    end

    def stop
      # stop checker loop
      @timer.stop
    end

    def check_url(url)
      response = check_http_status_of(url)
      if response.code != 200.to_s && !recurrent_code?(url, response.code)
        add_code_to_resp_stack(response.code, url)
        send_email(url, response)
      end
      [url, response.code, response.message]
    end

    private

    def check_http_status_of(url)
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == "https"
      request = Net::HTTP::Get.new(uri.request_uri)
      http.request(request)
    end

    def recurrent_code?(url, resp_code)
      synchronize do
        @resp_stack.each_pair do |key, val|
          return true if key==resp_code && val==url
        end
      end
      return false
    end

    def add_code_to_resp_stack(code, url)
      synchronize do
        @resp_stack.merge!("#{code}" => url)
      end
    end

    def send_email(url, resp)
      StatusChecker::Email.new(@email).send(url, resp)
    end
  end
end
