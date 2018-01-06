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
    File.open( 'watchers.txt' ).readlines.each do |watcher|
      p watcher
      smtp.send_message message, 'webapp@trac.deadzed.net', watcher
    end
  end
end

send_warning_email( 'test' )

File.open( 'sites.txt' ).readlines.each do |site|
  uri = URI.parse(site)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true

  request = Net::HTTP::Get.new(uri.request_uri)
  res = http.request(request)

  puts "#{site} : #{res.code}"

  unless [ 200, 401 ].include?( res.code )
    send_warning_email( site )
  end

end