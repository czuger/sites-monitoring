require 'net/https'
require 'uri'
require 'net/smtp'

def send_warning_email( sitename )
  message = <<MESSAGE_END
From: Private Person <me@fromdomain.com>
To: A Test User <test@todomain.com>
Subject: SMTP e-mail test

This is a test e-mail message.
MESSAGE_END

  Net::SMTP.start('localhost') do |smtp|
    watchers = File.open( 'watchers.txt' ).readlines
    p watchers
    smtp.send_message message, watchers
  end
end

send_warning_email( 'test' )

File.open( 'sites.txt' ).readlines.each do |site|
  uri = URI.parse(site)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true

  request = Net::HTTP::Get.new(uri.request_uri)
  res = http.request(request)

  unless [ 200, 401 ].include?( res.code )
    send_warning_email( site )
  end

end