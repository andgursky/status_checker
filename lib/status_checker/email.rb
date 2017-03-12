require 'net/smtp'
require 'pry'

module StatusChecker
  class Email
    def initialize(receivers)
      raise ArgumentError, "receivers can't be empty" if receivers.empty?
      @receivers = receivers
      @addres = 'smtp.mail.ru'
      @port = 465
      @domain = 'mail.ru'
      @authentication = :plain
      @user_name = 'technical_root@mail.ru'
      @password = 'qwerty123456'
      @smtp = Net::SMTP.new(@addres, @port)
      @smtp.enable_tls
    end

    def send(url, response)
      begin
        @smtp.start(@domain, @user_name, @password, @authentication)
        @receivers.each do |email|
          @smtp.send_message message(url, response, email), @user_name, email
        end
      ensure
        @smtp.finish
      end
    end

    private

    def message(url, response, email)
      "From:<#{@user_name}>\n" \
      "To:<#{email}>\n" \
      "MIME-Version: 1.0\n" \
      "Content-type: text/html\n" \
      "Subject: Attention!!!\n" \
      "<h1 style='color:red'><b>!!!ATTENTION!!!</b></h1>\n" \
      "<p>The host #{url} #{response.message} and has " \
      "<b>code: #{response.code}</b></p>"
    end
  end
end
